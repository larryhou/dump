package com.larrio.dump.flash.display.shape.collector
{
	import com.larrio.dump.flash.display.shape.canvas.ICanvas;
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
	 * 矢量图信息收集器
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:17:55 PM
	 */
	public class ShapeInfoCollector implements IShapeCollector
	{
		private static const TWIPS_PER_PIXEL:uint = 20;
		
		private var _shape:Shape;
		private var _canvas:ICanvas;
		
		private var _fillStyles:Vector.<FillStyle>;
		private var _lineStyles:Vector.<LineStyle>;
		
		private var _lineIndex:uint;
		
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
		public function ShapeInfoCollector(shape:Shape)
		{
			_shape = shape;
			
			if (_shape is ShapeWithStyle)
			{
				_fillStyles = (_shape as ShapeWithStyle).fillStyles.styles;
				_lineStyles = (_shape as ShapeWithStyle).lineStyles.styles;
			}
			
			_components = new Vector.<StyleComponent>;
			_components.push(_style = new StyleComponent(_fillStyles, _lineStyles));
		}
		
		/**
		 * 在canvas上绘制矢量数据 
		 * @param canvas	实现ICanvas接口的对象
		 */		
		public function drawVectorOn(canvas:ICanvas):void
		{
			_canvas = canvas;
			_position = new Point(0,0);
			
			var records:Vector.<ShapeRecord> = _shape.records;
			
			for (var i:int = 0, length:uint = records.length; i < length; i++)
			{
				if (records[i] is CurvedEdgeRecord)
				{
					makeCurve(records[i] as CurvedEdgeRecord);					
				}
				else
				if (records[i] is StraightEdgeRecord)
				{
					makeLine(records[i] as StraightEdgeRecord);
				}
				else
				if (records[i] is StyleChangeRecord)
				{
					changeStyle(records[i] as StyleChangeRecord);
				}
			}
			
			renderShape();
		}
		
		/**
		 * 给线稿上色
		 */		
		private function renderShape():void
		{
			var collect:Vector.<ShapeEdge>;
			
			var comp:StyleComponent;
			var map0:Dictionary, map1:Dictionary;
			
			var length:uint, i:uint;
			for (i = 0, length = _components.length; i < length; i++)
			{
				comp = _components[i];
				
				map0 = comp.map0;
				map1 = comp.map1;
				
				var sub:Array, item:ShapeEdge, slen:uint, j:uint;
				for (var style:uint = comp.maxIndex; style >= 1; style--)
				{
					collect = new Vector.<ShapeEdge>;
					sub = map1[style];
					if (sub)
					{
						for (j = 0, slen = sub.length; j < slen; j++)
						{
							collect.push(ShapeEdge(sub[j]).tearOff(false));
						}
					}
					
					sub = map0[style];
					if (sub)
					{
						for (j = 0, slen = sub.length; j < slen; j++)
						{
							collect.push(ShapeEdge(sub[j]).tearOff(true));
						}
					}
					
					encloseAreas(collect, comp, style);
				}
				
				var edge:ShapeEdge;
				for (var m:uint = 0, mlen:uint = comp.edges.length; m < mlen; m++)
				{
					edge = comp.edges[m];
					
					if (!edge.lineStyle) continue;
					
					changeLineStyle(comp.lineStyles[edge.lineStyle - 1]);
					
					_canvas.beginFill(0, 0);
					_canvas.moveTo(edge.x1, edge.y1);
					
					if (edge.curved)
					{
						_canvas.curveTo(edge.ctrlX, edge.ctrlY, edge.x2, edge.y2);
					}
					else
					{
						_canvas.lineTo(edge.x2, edge.y2);
					}
					
					_canvas.lineStyle(NaN);
					_canvas.endFill();
				}
				
			}			
		}
		
		/**
		 * 迭代渲染核心 
		 */		
		private function encloseAreas(list:Vector.<ShapeEdge>, comp:StyleComponent, style:uint):void
		{
			var map:Dictionary = new Dictionary(true);
			
			var edge:ShapeEdge;
			var key:String, skey:String;
			
			var i:uint, length:uint;
			for (i = 0, length = list.length; i < length; i++)
			{
				edge = list[i];
				key = createKey(edge.x1, edge.y1);
				
				if (!map[key]) map[key] = [];
				map[key].push(edge);
			}
			
			var loops:Vector.<Vector.<ShapeEdge>> = new Vector.<Vector.<ShapeEdge>>;
			var parts:Vector.<ShapeEdge>;
			
			var item:ShapeEdge;
			
			var visit:Dictionary;
			for (i = 0, length = list.length; i < length; i++)
			{
				edge = list[i];
				if (edge.loop) continue;
				
				edge.loop = true;
				parts = new Vector.<ShapeEdge>();
				parts.push(edge);
				
				visit = new Dictionary(true);
				for (skey = createKey(edge.x1, edge.y1);;)
				{
					key = createKey(edge.x2, edge.y2);
					if (key == skey)
					{
						for each(item in parts) item.loop = true;
						loops.push(parts);
						break;
					}
					
					if (!map[key] || !map[key].length) break;
					
					item = seekNextEdge(map[key], (i < list.length - 1)? list[i + 1] : null, visit);
					if (!item) break;
					
					edge = item;
					visit[edge] = true;
					
					parts.push(edge);
				}
			}
			
			// 存储封闭曲线
			comp.dict[style] = parts;
			
			_canvas.lineStyle(NaN);
			
			comp.styles && changeFillStyle(comp.styles[style - 1]);
			for each(parts in loops) renderColor(parts);
			
			_canvas.endFill();
		}
		
		private function seekNextEdge(list:Array, edge:ShapeEdge, visit:Dictionary):ShapeEdge
		{
			if (!edge) return null;
			
			var item:ShapeEdge;
			
			var len:uint, i:uint;
			for (i = 0, len = list.length; i < len; i++)
			{
				item = list[i];
				if (item == edge && !item.loop)
				{
					list.splice(i, 1);
					return item;
				}
			}			
			
			for (i = 0, len = list.length; i < len; i++)
			{
				item = list[i];
				if (!item.loop && !visit[item]) return item;
			}
			
			return null;
		}
		
		/**
		 * 把一个封闭路径绘制成填充区域
		 */		
		private function renderColor(loop:Vector.<ShapeEdge>):void
		{
			var edge:ShapeEdge;
			
			_canvas.moveTo(loop[0].x1, loop[0].y1);
			for (var i:uint = 0, length:uint = loop.length; i < length; i++)
			{
				edge = loop[i];
				if (edge.curved)
				{
					_canvas.curveTo(edge.ctrlX, edge.ctrlY, edge.x2, edge.y2);
				}
				else
				{
					_canvas.lineTo(edge.x2, edge.y2);
				}
			}
		}
		
		/**
		 * 绘制直线 
		 */		
		private function makeLine(record:StraightEdgeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(false);
			
			edge.x1 = _position.x;
			edge.y1 = _position.y;
			edge.x2 = _position.x += record.deltaX / TWIPS_PER_PIXEL;
			edge.y2 = _position.y += record.deltaY / TWIPS_PER_PIXEL;
			
			recordEdge(edge);
		}
		
		/**
		 * 绘制贝塞尔弧线 
		 */		
		private function makeCurve(record:CurvedEdgeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(true);
			
			edge.x1 = _position.x;
			edge.y1 = _position.y;
			
			edge.ctrlX = _position.x += record.deltaControlX /  TWIPS_PER_PIXEL;
			edge.ctrlY = _position.y += record.deltaControlY / TWIPS_PER_PIXEL;
			
			edge.x2 = _position.x += record.deltaAnchorX / TWIPS_PER_PIXEL;
			edge.y2 = _position.y += record.deltaAnchorY / TWIPS_PER_PIXEL;
			
			recordEdge(edge);
		}
		
		/**
		 * 记录线条边界信息 
		 */		
		private function recordEdge(edge:ShapeEdge):void
		{
			edge.lineStyle = _lineIndex;
			
			_style.edges.push(edge);
			
			if (_f0)
			{
				if (!_style.map0[_f0])
				{
					_style.map0[_f0] = [];
				}
				
				_style.map0[_f0].push(edge);
			}
			
			
			if (_f1)
			{
				if (!_style.map1[_f1])
				{
					_style.map1[_f1] = [];
				}
				
				_style.map1[_f1].push(edge);
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
			}
			
			if (record.stateNewStyles)
			{
				_fillStyles = record.fillStyles.styles;
				_lineStyles = record.lineStyles.styles;
				
				_components.push(_style = new StyleComponent(_fillStyles, _lineStyles));
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
				_lineIndex = record.lineStyle;
			}
		}
		
		/**
		 * 改变线型样式 
		 */		
		private function changeLineStyle(style:LineStyle):void
		{
			var data:Object = {};
			data["thickness"] = style.width / TWIPS_PER_PIXEL;
			
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
				
				data["limit"] = 3;
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
			return x.toFixed(12) + "_" + y.toFixed(12);
		}

		/**
		 * 矢量图形分类信息
		 */		
		public function get components():Vector.<StyleComponent> { return _components; }

	}
}

import com.larrio.dump.model.shape.FillStyle;
import com.larrio.dump.model.shape.LineStyle;

import flash.utils.Dictionary;

class StyleComponent
{
	/**
	 * 样式列表 
	 */	
	public var styles:Vector.<FillStyle>;
	public var lineStyles:Vector.<LineStyle>;
	
	public var maxIndex:uint;
	
	public var map0:Dictionary;
	public var map1:Dictionary;
	
	public var dict:Dictionary;
	
	public var edges:Vector.<ShapeEdge>;
	
	public function StyleComponent(styles:Vector.<FillStyle>, lineStyles:Vector.<LineStyle>)
	{
		this.styles = styles; this.lineStyles = lineStyles;
		
		this.map0 = new Dictionary(false);
		this.map1 = new Dictionary(false);
		this.dict = new Dictionary(false);
		
		this.edges = new Vector.<ShapeEdge>;
		
	}
}
 
// 图形边界线条
class ShapeEdge
{	
	/**
	 * 线条起点坐标 
	 */	
	public var x1:Number;
	public var y1:Number;
	
	/**
	 * 贝塞尔曲线控制点坐标 
	 */	
	public var ctrlX:Number;
	public var ctrlY:Number;
	
	/**
	 * 线条终点坐标
	 */	
	public var x2:Number;
	public var y2:Number;
	
	public var curved:Boolean;
	
	// 用来做填充渲染
	public var loop:Boolean;
	
	/**
	 * 线条样式 
	 */	
	public var lineStyle:uint;
	
	public function ShapeEdge(curved:Boolean)
	{
		this.curved = curved;
		this.x1 = this.y1 = this.ctrlX = this.ctrlY = this.x2 = this.y2 = 0;
	}
	
	/**
	 * 从当前对象分裂出一个新的ShapeEdge对象 
	 * @param reverse	是否需要首位对调：矢量反转
	 */	
	public function tearOff(reverse:Boolean):ShapeEdge
	{
		var edge:ShapeEdge = new ShapeEdge(this.curved);
		if (reverse)
		{
			edge.x1 = this.x2;
			edge.y1 = this.y2;
			
			edge.x2 = this.x1;
			edge.y2 = this.y1;
		}
		else
		{
			edge.x1 = this.x1;
			edge.y1 = this.y1;
			
			edge.x2 = this.x2;
			edge.y2 = this.y2;
		}
		
		edge.ctrlX = this.ctrlX;
		edge.ctrlY = this.ctrlY;
		
		return edge;
	}
}