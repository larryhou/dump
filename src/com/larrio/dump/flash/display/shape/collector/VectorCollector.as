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
	 * 矢量图收集器
	 * @author doudou
	 * @createTime Mar 27, 2013 11:41:12 PM
	 */
	public class VectorCollector implements IShapeCollector
	{
		private static const TWIPS_PER_PIXEL:uint = 20;
		
		private var _shape:Shape;
		
		private var _position:Point;
		
		private var _map0:Dictionary;
		private var _map1:Dictionary;
		
		private var _f0:uint;
		private var _f1:uint;
		private var _maxIndex:uint;
		
		private var _line:uint;
		
		private var _edges:Array;
		
		private var _lineStyles:Vector.<LineStyle>;
		private var _fillStyles:Vector.<FillStyle>;
		
		private var _canvas:ICanvas;
		
		/**
		 * 构造函数
		 * create a [VectorCollector] object
		 */
		public function VectorCollector(shape:Shape)
		{
			_shape = shape;
			
			if (_shape is ShapeWithStyle)
			{
				_lineStyles = (_shape as ShapeWithStyle).lineStyles.styles;
				_fillStyles = (_shape as ShapeWithStyle).fillStyles.styles;
			}
			
			_edges = [];
			_map0 = new Dictionary(true);
			_map1 = new Dictionary(true);
		}
		
		/**
		 * 在画板上绘制矢量数据 
		 * @param canvas	矢量画板
		 */		
		public function drawVectorOn(canvas:ICanvas):void
		{
			_canvas = canvas;
			_position = new Point(0, 0);
			
			var records:Vector.<ShapeRecord> = _shape.records;
			for (var i:int = 0, length:uint = records.length; i < length; i++)
			{
				if (records[i] is StraightEdgeRecord)
				{
					drawStraightEdge(records[i] as StraightEdgeRecord);
				}
				else
				if (records[i] is CurvedEdgeRecord)
				{
					drawCurvedEdge(records[i] as CurvedEdgeRecord);
				}
				else
				if (records[i] is StyleChangeRecord)
				{
					drawStyleChange(records[i] as StyleChangeRecord);
				}
				else
				{
					flush();
				}
			}
		}
		
		/**
		 * 切换线条、填充样式
		 */		
		private function drawStyleChange(record:StyleChangeRecord):void
		{
			if (record.stateMoveTo)
			{
				_position.x = record.moveToX / TWIPS_PER_PIXEL;
				_position.y = record.moveToY / TWIPS_PER_PIXEL;
			}
			
			if (record.stateNewStyles)
			{
				flush();
				
				_lineStyles = record.lineStyles.styles;
				_fillStyles = record.fillStyles.styles;
			}
			
			if (record.stateLineStyle)
			{
				_line = record.lineStyle;
			}
			
			if (record.stateFillStyle0)
			{
				_f0 = record.fillStyle0;
				if (_f0 > _maxIndex) _maxIndex = _f0;
			}
			
			if (record.stateFillStyle1)
			{
				_f1 = record.fillStyle1;
				if (_f1 > _maxIndex) _maxIndex = _f1;
			}
		}
		
		/**
		 * 处理直线
		 */		
		private function drawStraightEdge(record:StraightEdgeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(false);
			edge.x1 = _position.x;
			edge.y1 = _position.y;
			
			edge.x2 = _position.x += record.deltaX / TWIPS_PER_PIXEL;
			edge.y2 = _position.y += record.deltaY / TWIPS_PER_PIXEL;
			
			storeEdge(edge);
		}
		
		/**
		 * 处理二阶贝塞尔曲线
		 */		
		private function drawCurvedEdge(record:CurvedEdgeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(true);
			edge.x1 = _position.x;
			edge.y1 = _position.y;
			
			edge.ctrX = _position.x += record.deltaControlX / TWIPS_PER_PIXEL;
			edge.ctrY = _position.y += record.deltaControlY / TWIPS_PER_PIXEL;
			
			edge.x2 = _position.x += record.deltaAnchorX / TWIPS_PER_PIXEL;
			edge.y2 = _position.y += record.deltaAnchorY / TWIPS_PER_PIXEL;
			
			storeEdge(edge);
		}
		
		/**
		 * 存储边界对象
		 */		
		private function storeEdge(edge:ShapeEdge):void
		{
			edge.lineStyle = _line;
			
			_edges.push(edge);
			
			if (_f0)
			{
				if (!_map0[_f0]) _map0[_f0] = [];
				_map0[_f0].push(edge);
			}
			
			if (_f1)
			{
				if (!_map1[_f1]) _map1[_f1] = [];
				_map1[_f1].push(edge);
			}
		}
		
		/**
		 * 渲染缓冲区数据并清空
		 */		
		private function flush():void
		{
			var length:uint, i:uint;
			
			var list:Array;
			var collect:Vector.<RenderEdge>;
			for (var style:uint = _maxIndex; style >= 1; style--)
			{
				collect = new Vector.<RenderEdge>;
				
				list = _map1[style];
				if (list)
				{
					for (i = 0, length = list.length; i < length; i++)
					{
						collect.push((list[i] as ShapeEdge).tearOff(false));
					}
				}
				
				list = _map0[style];
				if (list)
				{
					for (i = 0, length = list.length; i < length; i++)
					{
						collect.push((list[i] as ShapeEdge).tearOff(true));
					}
				}				
								
				encloseArea(collect, style);
			}
			
			_map0 = new Dictionary(true);
			_map1 = new Dictionary(true);
			
			var edge:ShapeEdge;
			for (i = 0, length = _edges.length; i < length; i++)
			{
				edge = _edges[i];
				if (!edge.lineStyle) continue;
				
				changeLineStyle(_lineStyles[edge.lineStyle - 1]);
				
				_canvas.beginFill(0, 0);
				_canvas.moveTo(edge.x1, edge.y1);
				
				if (edge.curved)
				{
					_canvas.curveTo(edge.ctrX, edge.ctrY, edge.x2, edge.y2);
				}
				else
				{
					_canvas.lineTo(edge.x2, edge.y2);
				}
				
				_canvas.lineStyle(NaN);
				_canvas.endFill();
			}
			
			_edges = [];
			_maxIndex = 0;
		}
		
		/**
		 * 在同一样式的边界里面查找封闭区域并着色
		 */		
		private function encloseArea(list:Vector.<RenderEdge>, style:uint):void
		{
			var map:Dictionary = new Dictionary(false);
			
			var edge:RenderEdge;
			var key:String, skey:String;
			
			var length:uint, i:uint;
			for (i = 0, length = list.length; i < length; i++)
			{
				edge = list[i];
				key = createKey(edge.x1, edge.y1);
				if (!map[key]) map[key] = [];
				map[key].push(edge);
			}
			
			var loops:Array = [];
			var parts:Vector.<RenderEdge>;
			
			var visit:Dictionary, item:RenderEdge;
			for (i = 0, length = list.length; i < length; i++)
			{
				edge = list[i];
				if (edge.loop) continue;
				
				edge.loop = true;
				parts = new Vector.<RenderEdge>;
				parts.push(edge);
				
				visit = new Dictionary(true);
				for (skey = createKey(edge.x1, edge.y1);;)
				{
					key = createKey(edge.x2, edge.y2);
					if (key == skey)
					{
						for each (item in parts) item.loop = true;
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
			   
			_canvas.lineStyle(NaN);
			
			changeFillStyle(_fillStyles[style - 1]);
			for each (parts in loops) renderColor(parts);
			
			_canvas.endFill();
		}
		
		/**
		 * 查找下一个边界
		 */		
		private function seekNextEdge(list:Array, edge:RenderEdge, visit:Dictionary):RenderEdge
		{
			if (!edge) return null;
			
			var item:RenderEdge;
			
			var length:uint, i:uint;
			for (i = 0, length = list.length; i < length; i++)
			{
				item = list[i];
				if (item == edge && !item.loop)
				{
					list.splice(i, 1);
					return item;
				}
			}
			
			for (i = 0, length = list.length; i < length; i++)
			{
				item = list[i];
				if (!item.loop && !visit[item]) return item;
			}
			
			return null;
		}
		
		/**
		 * 绘制封闭区域并着色
		 */		
		private function renderColor(list:Vector.<RenderEdge>):void
		{
			var edge:RenderEdge;
			
			_canvas.moveTo(list[0].x1, list[0].y1);
			for (var i:int = 0, length:uint = list.length; i < length; i++)
			{
				edge = list[i];
				if (edge.curved)
				{
					_canvas.curveTo(edge.ctrX, edge.ctrY, edge.x2, edge.y2);
				}
				else
				{
					_canvas.lineTo(edge.x2, edge.y2);
				}
			}
		}
		
		/**
		 * 改变线型样式 
		 */		
		private function changeLineStyle(style:LineStyle):void
		{
			var data:Object = [];
			
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
					case 1:	data["scale"] = LineScaleMode.HORIZONTAL;break;
					case 2:	data["scale"] = LineScaleMode.VERTICAL;break;
					case 3:	data["scale"] = LineScaleMode.NONE;break;
					default:data["scale"] = LineScaleMode.NORMAL;break;
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
		
	}
}

class ShapeEdge
{
	public var x1:Number;
	public var y1:Number;
	
	public var x2:Number;
	public var y2:Number;
	
	public var ctrX:Number;
	public var ctrY:Number;
	
	public var lineStyle:uint;
	
	public var curved:Boolean;
	
	public function ShapeEdge(curved:Boolean)
	{
		this.curved = curved;
	}
	
	public function tearOff(reverse:Boolean):RenderEdge
	{
		var edge:RenderEdge = new RenderEdge(this.curved);
		if(reverse)
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
		
		edge.ctrX = this.ctrX;
		edge.ctrY = this.ctrY;
		
		return edge;
	}
}

class RenderEdge extends ShapeEdge
{
	public var loop:Boolean;
	
	public function RenderEdge(curved:Boolean)
	{
		super(curved);
	}
	
}