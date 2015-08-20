package com.larrio.dump.flash.display.shape.canvas
{
	import flash.display.BitmapData;
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Aug 19, 2015 8:17:09 PM
	 */
	public class JSONCanvas implements ICanvas
	{
		private var steps:Array;
		
		/**
		 * 构造函数
		 * create a [JsonCanvas] object
		 */
		public function JSONCanvas()
		{
			steps = [];
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			var data:Object = {};
			data.thickness = thickness;
			data.color = color;
			data.alpha = alpha;
			data.pixelHinting = pixelHinting;
			data.scaleMode = scaleMode;
			data.caps = caps;
			data.joints = joints;
			data.miterLimit = miterLimit;
			steps.push(["LINE_STYLE", data]);
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			var data:Object = {};
			data.x = x;
			data.y = y;
			steps.push(["MOVE_TO", data]);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			var data:Object = {};
			data.x = x;
			data.y = y;
			steps.push(["LINE_TO", data]);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			var data:Object = {};
			data.controlX = controlX;
			data.controlY = controlY;
			data.anchorX = anchorX;
			data.anchorY = anchorY;
			steps.push(["CURVE_TO", data]);
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			var data:Object = {};
			data.color = color;
			data.alpha = alpha;
			steps.push(["BEGIN_FILL", data]);
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			var data:Object = {};
			data.bitmap = null;
			data.matrix = matrix;
			data.repeat = repeat;
			data.smooth = smooth;
			steps.push(["BEGIN_BITMAP_FILL", data]);
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			var data:Object = {};
			data.type = type;
			data.colors = colors;
			data.alphas = alphas;
			data.ratios = ratios;
			data.matrix = matrix;
			data.spreadMethod = spreadMethod;
			data.interpolationMethod = interpolationMethod;
			data.focalPointRatio = focalPointRatio;
			steps.push(["BEGIN_GRADIENT_FILL", data]);
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			var data:Object = {};
			data.type = type;
			data.colors = colors;
			data.alphas = alphas;
			data.ratios = ratios;
			data.matrix = matrix;
			data.spreadMethod = spreadMethod;
			data.interpolationMethod = interpolationMethod;
			data.focalPointRatio = focalPointRatio;
			steps.push(["LINE_GRADIENT_STYLE", data]);
		}
		
		public function endFill():void
		{
			var data:Object = {};
			steps.push(["END_FILL", {}]);
		}
		
		public function get jsonObject():String { return JSON.stringify(steps); }
	}
}