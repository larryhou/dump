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
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Mar 29, 2013 2:06:11 PM
	 */
	public class AbstractCollector implements IShapeCollector
	{
		protected static const TWIPS_PER_PIXEL:uint = 20;
		
		protected var _canvas:ICanvas;
		protected var _position:Point;
		
		protected var _shape:Shape;
		
		/**
		 * 构造函数
		 * create a [AbstractCollector] object
		 */
		public function AbstractCollector(shape:Shape)
		{
			_shape = shape;
		}
		
		public function drawVectorOn(canvas:ICanvas):void
		{
			_canvas = canvas;
			_position = new Point(0,0);
			
			var records:Vector.<ShapeRecord> = _shape.records;
			
			for (var i:int = 0, length:uint = records.length; i < length; i++)
			{
				if (records[i] is CurvedEdgeRecord)
				{
					drawCurvedEdge(records[i] as CurvedEdgeRecord);					
				}
				else
				if (records[i] is StraightEdgeRecord)
				{
					drawStraightEdge(records[i] as StraightEdgeRecord);
				}
				else
				if (records[i] is StyleChangeRecord)
				{
					changeStyle(records[i] as StyleChangeRecord);
				}
			}			
		}
		
		protected function changeStyle(record:StyleChangeRecord):void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function drawStraightEdge(recorder:StraightEdgeRecord):void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function drawCurvedEdge(record:CurvedEdgeRecord):void
		{
			// TODO Auto Generated method stub
			
		}
		
		/**
		 * 改变线型样式 
		 */		
		protected final function changeLineStyle(style:LineStyle):void
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
		protected final function changeFillStyle(style:FillStyle):void
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
		protected function changeBitmapFillStyle(style:FillStyle):void
		{
			// 暂时不考虑位图填充的情况
			_canvas.beginFill(0xFF00FF, 0.2);
		}
		
		/**
		 * 根据坐标生成唯一索引 
		 */		
		protected final function createKey(x:Number, y:Number):String
		{
			return x.toFixed(12) + "_" + y.toFixed(12);
		}
	}
}