package com.larrio.dump.flash.display.shape.collector
{
	import com.larrio.dump.flash.display.shape.canvas.ICanvas;
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.model.shape.CurvedEdgeShapeRecord;
	import com.larrio.dump.model.shape.FillStyle;
	import com.larrio.dump.model.shape.FocalGradient;
	import com.larrio.dump.model.shape.GradRecord;
	import com.larrio.dump.model.shape.Gradient;
	import com.larrio.dump.model.shape.LineStyle;
	import com.larrio.dump.model.shape.LineStyle2;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.model.shape.ShapeRecord;
	import com.larrio.dump.model.shape.StraightEdgeShapeRecord;
	import com.larrio.dump.model.shape.StyleChangeShapeRecord;
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
		public function AbstractCollector(shape:Shape = null)
		{
			shape && load(shape);
		}
		
		public function load(shape:Shape):void
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
				if (records[i] is CurvedEdgeShapeRecord)
				{
					drawCurvedEdge(records[i] as CurvedEdgeShapeRecord);					
				}
				else
				if (records[i] is StraightEdgeShapeRecord)
				{
					drawStraightEdge(records[i] as StraightEdgeShapeRecord);
				}
				else
				if (records[i] is StyleChangeShapeRecord)
				{
					changeShapeStyle(records[i] as StyleChangeShapeRecord);
				}
			}			
		}
		
		protected function changeShapeStyle(record:StyleChangeShapeRecord):void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function drawStraightEdge(recorder:StraightEdgeShapeRecord):void
		{
			// TODO Auto Generated method stub
			
		}
		
		protected function drawCurvedEdge(record:CurvedEdgeShapeRecord):void
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
					data["color"] = 0x000000;
					data["alpha"] = 1;
				}
				else
				{
					data["color"] = ls.color.rgb;
					data["alpha"] = (ls.color as RGBAColor).alpha / 0xFF;
				}
				
				_canvas.lineStyle(data["thickness"], data["color"], data["alpha"],  data["hinting"], data["scale"], data["caps"], data["joints"], data["limit"]);
				if (ls.hasFillFlag)
				{
					var gradient:GradientInfo = stripGraidentInfo(ls.style);
					_canvas.lineGradientStyle(gradient.type, gradient.colors, gradient.alphas, gradient.ratios, gradient.matrix, gradient.spreadMethod, gradient.interpolationMethod, gradient.focalPointRatio);
				}
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
		
		private function stripGraidentInfo(style:FillStyle):GradientInfo
		{
			var data:GradientInfo = new GradientInfo();
			data.focalPointRatio = 0;
			
			if (style.type == 0x10)
			{
				data.type = GradientType.LINEAR;
			}
			else
			{
				data.type = GradientType.RADIAL;
				if (style.type == 0x13)
				{
					data.focalPointRatio = fixed((style.gradient as FocalGradient).focalPoint, 8, 8);
				}
			}
			
			data.colors = [];
			data.alphas = [];
			data.ratios = [];
			
			var record:GradRecord;
			var length:uint = style.gradient.gradients.length;
			for (var i:int = 0; i < length; i++)
			{
				record = style.gradient.gradients[i];
				
				data.colors.push(record.color.rgb);
				if (record.color is RGBAColor)
				{
					data.alphas.push((record.color as RGBAColor).alpha / 0xFF);
				}
				else
				{
					data.alphas.push(1);
				}
				
				data.ratios.push(record.ratio);
			}
			
			switch (style.gradient.spreadMode)
			{
				case 0:data.spreadMethod = SpreadMethod.PAD;break;
				case 1:data.spreadMethod = SpreadMethod.REFLECT;break;
				case 2:data.spreadMethod = SpreadMethod.REPEAT;break;
			}
			
			switch (style.gradient.interpolationMode)
			{
				case 0:data.interpolationMethod = InterpolationMethod.RGB;break;
				case 1:data.interpolationMethod = InterpolationMethod.LINEAR_RGB;break;
			}
			
			data.matrix = style.gradientMatrix.matrix;
			
			return data;
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
					var gradient:GradientInfo = stripGraidentInfo(style);
					_canvas.beginGradientFill(gradient.type, gradient.colors, gradient.alphas, gradient.ratios, gradient.matrix, gradient.spreadMethod, gradient.interpolationMethod, gradient.focalPointRatio);	
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
import flash.geom.Matrix;

//lineGradientStyle(type:String, 
//colors:Array, alphas:Array, 
//ratios:Array, matrix:Matrix = null, 
//spreadMethod:String = "pad", 
//interpolationMethod:String = "rgb", 
//focalPointRatio:Number = 0):void
class GradientInfo
{
	public var type:String;
	public var colors:Array;
	public var alphas:Array;
	public var ratios:Array;
	public var matrix:Matrix;
	public var spreadMethod:String;
	public var interpolationMethod:String;
	public var focalPointRatio:Number;
}