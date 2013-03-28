package com.larrio.dump.flash.display.shape
{
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.model.shape.CurvedEdgeRecord;
	import com.larrio.dump.model.shape.FillStyle;
	import com.larrio.dump.model.shape.FocalGradient;
	import com.larrio.dump.model.shape.GradRecord;
	import com.larrio.dump.model.shape.LineStyle;
	import com.larrio.dump.model.shape.LineStyle2;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.model.shape.ShapeRecord;
	import com.larrio.dump.model.shape.ShapeWithStyle;
	import com.larrio.dump.model.shape.StraightEdgeRecord;
	import com.larrio.dump.model.shape.StyleChangeRecord;
	import com.larrio.math.fixed;
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * Shape矢量数据收集器
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:17:55 PM
	 */
	public class ShapeVectorCollector
	{
		private static const TWIPS_PER_PIXEL:Number = 1.0;
		
		private var _shape:Shape;
		private var _canvas:ICanvas;
		
		private var _fstyles:Vector.<FillStyle>;
		private var _lstyles:Vector.<LineStyle>;
		
		private var _records:Vector.<ShapeRecord>;
		
		private var _lineStyle:Object;
		private var _dict:Dictionary;
		
		private var _f0:uint;
		private var _f1:uint;
		private var _style:StyleComponent;
		
		private var _position:Point;
		
		private var _components:Vector.<StyleComponent>;
		
		/**
		 * 构造函数
		 * create a [ShapeVectorCollector] object
		 * @param shape	Shape矢量数据描述对象
		 */		
		public function ShapeVectorCollector(shape:Shape)
		{
			_shape = shape;
			
			if (_shape is ShapeWithStyle)
			{
				_fstyles = (_shape as ShapeWithStyle).fillStyles.styles;
				_lstyles = (_shape as ShapeWithStyle).lineStyles.styles;
			}
			
			_records = _shape.records;
			
			_components = new Vector.<StyleComponent>;
			_components.push(_style = new StyleComponent(_fstyles));
			
			_lineStyle = {};
		}
		
		/**
		 * 在canvas上绘制矢量数据 
		 * @param canvas	实现ICanvas接口的对象
		 */		
		public function drawVectorOn(canvas:ICanvas):void
		{
			_canvas = canvas;
			_dict = new Dictionary();
			_position = new Point(0,0);
			
			for (var i:int = 0, length:uint = _records.length; i < length; i++)
			{
				if (_records[i] is CurvedEdgeRecord)
				{
					makeCurve(_records[i] as CurvedEdgeRecord);					
				}
				else
				if (_records[i] is StraightEdgeRecord)
				{
					makeLine(_records[i] as StraightEdgeRecord);
				}
				else
				if (_records[i] is StyleChangeRecord)
				{
					changeStyle(_records[i] as StyleChangeRecord);
				}
				else
				{
					_canvas.endFill();
				}
			}
			
			renderColor();
			
			trace(_canvas);
		}
		
		/**
		 * 给线稿上色
		 */		
		private function renderColor():void
		{
			_canvas.lineStyle(NaN);
			
			_canvas.endFill();
			_canvas.beginFill(0, 0);
			
			var map:Dictionary;
			var list:Vector.<ShapeEdge>;
			
			var sub:Array;
			for (var comp:StyleComponent, i:uint = 0, len:uint = _components.length; i < len; i++)
			{
				comp = _components[i];
				
				var style:FillStyle;
				for (var color:ColorComponent, j:uint = 1; j < comp.maxIndex; j++)
				{
					color = comp.map[j];
					style = comp.styles[color.style - 1];
					
					list = new Vector.<ShapeEdge>;
					
					var k:uint, slen:uint;
					for each(sub in color.map1)
					{
						if (sub.length)
						{
							for (k = 0, slen = sub.length; k < slen; k++)
							{
								list.push((sub[k] as ShapeEdge).tearOff(false));
							}
						}
					}
					
					// 矢量反转
					for each(sub in color.map0)
					{
						if (sub.length)
						{
							for (k = 0, slen = sub.length; k < slen; k++)
							{
								list.push((sub[k] as ShapeEdge).tearOff(true));
							}
						}
					}

					// 设置填充样式
					changeFillStyle(style);
					loopKernel(list);
				}

			}
		}
		
		/**
		 * 迭代渲染核心 
		 */		
		private function loopKernel(list:Vector.<ShapeEdge>):void
		{
			var map:Dictionary = new Dictionary(true);
			
			var edge:ShapeEdge, key:String, skey:String;
			
			var i:uint, length:uint;
			for (i = 0, length = list.length; i < length; i++)
			{
				edge = list[i];
				
				key = createKey(edge.x, edge.y);
				if (!map[key]) map[key] = [];
				map[key].push(edge);
			}
			
			var parts:Vector.<Vector.<ShapeEdge>> = new Vector.<Vector.<ShapeEdge>>;
			
			// 单个封闭区域
			var loop:Vector.<ShapeEdge>;
			
			var item:ShapeEdge;
			
			var visit:Dictionary;
			
			for (i = 0, length = list.length; i < length; i++)
			{
				edge = list[i];
				if (edge.loop) continue;
				
				edge.loop = true;
				loop = new Vector.<ShapeEdge>();
				loop.push(edge);
				
				visit = new Dictionary(true);
				for (skey = createKey(edge.x, edge.y);;)
				{
					key = createKey(edge.tx, edge.ty);
					if (key == skey)
					{
						for each(item in loop) item.loop = true;
						parts.push(loop);
						break;
					}
					
					if (!map[key] || !map[key].length) break;
					
					item = seekNextEdge(map[key], list[i + 1], visit);
					if (!item) break;
					
					edge = item;
					visit[edge] = true;
					
					loop.push(edge);
				}
			}
			
			for (i = 0, length = parts.length; i < length; i++) encloseArea(parts[i]);
		}
		
		/**
		 * 把一个封闭路径绘制成填充区域
		 */		
		private function encloseArea(loop:Vector.<ShapeEdge>):void
		{
			var edge:ShapeEdge;
			
			_canvas.moveTo(loop[0].x, loop[0].y);
			for (var i:uint = 0, length:uint = loop.length; i < length; i++)
			{
				edge = loop[i];
				if (edge.curve)
				{
					_canvas.curveTo(edge.ctrlX, edge.ctrlY, edge.tx, edge.ty);
				}
				else
				{
					_canvas.lineTo(edge.tx, edge.ty);
				}
			}
			
			_canvas.endFill();
		}
		
		private function seekNextEdge(list:Array, edge:ShapeEdge, visit:Dictionary):ShapeEdge
		{
			var item:ShapeEdge;
			
			var len:uint, i:uint;
			for (i = 0, len = list.length; i < len; i++)
			{
				item = list[i];
				if (!item.loop && !visit[item]) return item;
			}
			
			for (i = 0, len = list.length; i < len; i++)
			{
				item = list[i];
				if (item == edge && !item.loop)
				{
					list.splice(i, 1);
					return item;
				}
			}
			
			return null;
		}
		
		/**
		 * 绘制直线 
		 */		
		private function makeLine(record:StraightEdgeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(false);
			
			edge.x = _position.x;
			edge.y = _position.y;
			edge.tx = _position.x += record.deltaX / TWIPS_PER_PIXEL;
			edge.ty = _position.y += record.deltaY / TWIPS_PER_PIXEL;
			
			recordEdge(edge);
			
			_canvas.lineTo(edge.tx, edge.ty);
		}
		
		/**
		 * 绘制贝塞尔弧线 
		 */		
		private function makeCurve(record:CurvedEdgeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(true);
			
			edge.x = _position.x;
			edge.y = _position.y;
			
			edge.ctrlX = _position.x += (record.deltaControlX /  TWIPS_PER_PIXEL);
			edge.ctrlY = _position.y += (record.deltaControlY / TWIPS_PER_PIXEL);
			
			edge.tx = _position.x += (record.deltaAnchorX / TWIPS_PER_PIXEL);
			edge.ty = _position.y += (record.deltaAnchorY / TWIPS_PER_PIXEL);
			
			recordEdge(edge);
			
			_canvas.curveTo(edge.ctrlX, edge.ctrlY, edge.tx, edge.ty);
		}
		
		/**
		 * 记录线条边界信息 
		 */		
		private function recordEdge(edge:ShapeEdge):void
		{
			var dict:Dictionary = _style.map;
			var key:String = createKey(edge.x, edge.y);
			
			var color:ColorComponent;
			
			if (_f0)
			{
				if (!dict[_f0]) 
				{
					dict[_f0] = new ColorComponent(_f0);
				}
				
				color = dict[_f0] as ColorComponent;
				color.edges.push(edge);
				
				if (!color.map0[key])
				{
					color.map0[key] = [];
				}
				
				color.map0[key].push(edge);
			}
			
			
			if (_f1)
			{
				if (!dict[_f1]) 
				{
					dict[_f1] = new ColorComponent(_f1);
				}
				
				color = dict[_f1] as ColorComponent;
				color.edges.push(edge);
				
				if (!color.map1[key])
				{
					color.map1[key] = [];
				}
				
				color.map1[key].push(edge);
			}
			
		}
		
		/**
		 * 切换样式 
		 * @param style	线条、填充样式
		 */		
		private function changeStyle(record:StyleChangeRecord):void
		{
			if (record.stateMoveTo)
			{
				_position.x = record.moveToX / TWIPS_PER_PIXEL;
				_position.y = record.moveToY / TWIPS_PER_PIXEL;
				_canvas.moveTo(_position.x, _position.y);
			}
			
			if (_shape is ShapeWithStyle)
			{
				if (record.stateNewStyles)
				{
					_fstyles = record.fillStyles.styles;
					_lstyles = record.lineStyles.styles;
					
					_components.push(_style = new StyleComponent(_fstyles));
				}
				
				if (record.stateFillStyle0)
				{
					_f0 = record.fillStyle0;
					if (_f0 > _style.maxIndex) _style.maxIndex = _f0;
				}
				
				if (record.stateFillStyle1)
				{
					_f1 = record.fillStyle1;
					if (_f1 > _style.maxIndex) _style.maxIndex = _f1;
				}
				
				if (record.stateLineStyle)
				{
					if (record.lineStyle)
					{
						changeLineStyle(_lstyles[record.lineStyle - 1]);
					}
					else
					{
						_canvas.lineStyle(NaN);
					}
				}
			}
		}
		
		/**
		 * 改变线型样式 
		 */		
		private function changeLineStyle(style:LineStyle):void
		{
			var data:Object = {};
			data["thickness"] = style.width;
			
			var ls:LineStyle2;
			if (style is LineStyle2)
			{
				ls = style as LineStyle2;
				
				switch (ls.startCapStyle)
				{
					case 0:data["caps"] = CapsStyle.ROUND;break;
					case 1:data["caps"] = CapsStyle.NONE;break;
					case 2:data["caps"] = CapsStyle.SQUARE;break;
				}
				
				switch (ls.joinStyle)
				{
					case 0:data["joints"] = JointStyle.ROUND;break;
					case 1:data["joints"] = JointStyle.BEVEL;break;
					case 2:data["joints"] = JointStyle.MITER;break;
				}
				
				_lineStyle["limit"] = 3;
				if (ls.joinStyle == 2) data["limit"] = fixed(ls.miterLimitFactor, 8, 8);
				
				switch (ls.noHScaleFlag << 1 | ls.noVScaleFlag)
				{
					case 0:data["scale"] = LineScaleMode.NORMAL;break;
					case 1:data["scale"] = LineScaleMode.HORIZONTAL;break;
					case 2:data["scale"] = LineScaleMode.VERTICAL;break;
					case 3:data["scale"] = LineScaleMode.NONE;break;
				}
				
				data["hinting"] = Boolean(ls.pixelHintingFlag);
				
				if (ls.hasFillFlag)
				{
					changeFillStyle(ls.style);
				}
				else
				{
					data["color"] = ls.color.rgb;
					data["alpha"] = (ls.color as RGBAColor).alpha / 0xFF;
				}
				
				_canvas.lineStyle(data["thickness"], data["color"], data["alpha"],  data["hinting"], data["scale"], data["caps"], data["joints"], data["limit"]);
			}
			else
			{
				if (style.color is RGBAColor)
				{
					data["alpha"] = (style.color as RGBAColor).alpha / 0xFF;
				}
				else
				{
					data["alpha"] = 1;
				}
				
				data["color"] = style.color.rgb;
				_canvas.lineStyle(data["thickness"], data["color"], data["alpha"]);
			}
			
		}
		
		/**
		 * 改变填充样式 
		 */		
		private function changeFillStyle(style:FillStyle):void
		{
			var params:Array;
			
			switch (style.type)
			{
				case 0x00:
				{
					if (style.color is RGBAColor) 
					{
						_canvas.beginFill(style.color.rgb, (style.color as RGBAColor).alpha / 0xFF);
					}
					else
					{
						_canvas.beginFill(style.color.rgb);
					}
					
					break;
				}
					
				case 0x10:
				case 0x12:
				case 0x13:
				{
					var type:String;
					var focal:Number = 0;
					
					if (style.type == 0x10)
					{
						type = GradientType.LINEAR;
					}
					else
					{
						type = GradientType.RADIAL;
						if (style.type == 0x13)
						{
							focal = fixed((style.gradient as FocalGradient).focalPoint, 8, 8);
						}
					}
					
					var colors:Array = [];
					var alphas:Array = [];
					var ratios:Array = [];
					
					var record:GradRecord;
					var length:uint = style.gradient.gradients.length;
					for (var i:int = 0; i < length; i++)
					{
						record = style.gradient.gradients[i];
						
						colors.push(record.color.rgb);
						if (record.color is RGBAColor)
						{
							alphas.push((record.color as RGBAColor).alpha / 0xFF);
						}
						else
						{
							alphas.push(1);
						}
						
						ratios.push(record.ratio / 0xFF);
					}
					
					var spread:String;
					switch (style.gradient.spreadMode)
					{
						case 0:spread = SpreadMethod.PAD;break;
						case 1:spread = SpreadMethod.REFLECT;break;
						case 2:spread = SpreadMethod.REPEAT;break;
					}
					
					var interpolation:String;
					switch (style.gradient.interpolationMode)
					{
						case 0:interpolation = InterpolationMethod.RGB;break;
						case 1:interpolation = InterpolationMethod.LINEAR_RGB;break;
					}
					
					_canvas.beginGradientFill(type, colors, alphas, ratios, style.gradientMatrix.matrix, spread, interpolation, focal);	
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					changeBitmapFillStyle(style);
					break;
				}
					
			}
			
		}	
		
		/**
		 * 修改位图填充样式
		 */		
		private function changeBitmapFillStyle(style:FillStyle):void
		{
			// 暂时不考虑位图填充的情况
			_canvas.beginFill(0xFF00FF, 0.2);
		}
		
		/**
		 * 根据坐标生成唯一索引 
		 */		
		private function createKey(x:Number, y:Number):String
		{
			return x + "_" + y;
		}
	}
}

import com.larrio.dump.model.shape.FillStyle;
import com.larrio.dump.model.shape.ShapeRecord;

import flash.utils.Dictionary;

class StyleComponent
{
	/**
	 * 样式列表 
	 */	
	public var styles:Vector.<FillStyle>;
	
	public var maxIndex:uint;
		
	/**
	 * 存储ColorComponent映射 
	 */	
	public var map:Dictionary;
	
	public function StyleComponent(styles:Vector.<FillStyle>)
	{
		this.styles = styles;
		
		this.map = new Dictionary(false);
	}
}

// 相同填充色区域
class ColorComponent
{
	/**
	 * 样式索引 
	 */	
	public var style:uint;
	
	public var edges:Vector.<ShapeEdge>;
	
	/**
	 * 坐标映射表 
	 */	
	public var map0:Dictionary;
	public var map1:Dictionary;
	
	/**
	 * 封闭色块列表 
	 */	
	public var parts:Vector.<Array>;
	
	public function ColorComponent(style:uint)
	{
		this.style = style;
		this.parts = new Vector.<Array>;
		this.map0 = new Dictionary(false);
		this.map1 = new Dictionary(false);
		
		this.edges = new Vector.<ShapeEdge>;
	}
}

// 图形边界线条
class ShapeEdge
{	
	/**
	 * 线条起点坐标 
	 */	
	public var x:int;
	public var y:int;
	
	/**
	 * 贝塞尔曲线控制点坐标 
	 */	
	public var ctrlX:int;
	public var ctrlY:int;
	
	/**
	 * 线条终点坐标
	 */	
	public var tx:int;
	public var ty:int;
	
	public var curve:Boolean;
	
	// 用来做填充渲染
	public var loop:Boolean;
	
	public function ShapeEdge(curve:Boolean)
	{
		this.curve = curve;
		this.x = this.y = this.ctrlX = this.ctrlY = this.tx = this.ty = 0;
	}
	
	/**
	 * 从当前对象分裂出一个新的ShapeEdge对象 
	 * @param reverse	是否需要首位对调：矢量反转
	 */	
	public function tearOff(reverse:Boolean):ShapeEdge
	{
		var edge:ShapeEdge = new ShapeEdge(this.curve);
		if (reverse)
		{
			edge.x = this.tx;
			edge.y = this.ty;
			
			edge.tx = this.x;
			edge.ty = this.y;
		}
		else
		{
			edge.x = this.x;
			edge.y = this.y;
			
			edge.tx = this.tx;
			edge.ty = this.ty;
		}
		
		edge.ctrlX = this.ctrlX;
		edge.ctrlY = this.ctrlY;
		
		return edge;
	}
}