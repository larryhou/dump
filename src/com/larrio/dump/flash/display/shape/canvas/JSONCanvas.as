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
			data.method = "LINE_STYLE";
			data.thickness = thickness;
			data.color = color;
			data.alpha = alpha;
			data.pixelHinting = pixelHinting;
			data.scaleMode = scaleMode;
			data.caps = caps;
			data.joints = joints;
			data.miterLimit = miterLimit;
			steps.push(data);
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			var data:Object = {};
			data.method = "MOVE_TO";
			data.x = x;
			data.y = y;
			steps.push(data);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			var data:Object = {};
			data.method = "LINE_TO";
			data.x = x;
			data.y = y;
			steps.push(data);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			var data:Object = {};
			data.method = "CURVE_TO";
			data.controlX = controlX;
			data.controlY = controlY;
			data.anchorX = anchorX;
			data.anchorY = anchorY;
			steps.push(data);
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			var data:Object = {};
			data.method = "BEGIN_FILL";
			data.color = color;
			data.alpha = alpha;
			steps.push(data);
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			var data:Object = {};
			data.method = "BEGIN_BITMAP_FILL";
			data.bitmap = null;
			data.matrix = matrix;
			data.repeat = repeat;
			data.smooth = smooth;
			steps.push(data);
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			var data:Object = {};
			data.method = "BEGIN_GRADIENT_FILL";
			data.type = type;
			data.colors = colors;
			data.alphas = alphas;
			data.ratios = ratios;
			data.matrix = matrix;
			data.spreadMethod = spreadMethod;
			data.interpolationMethod = interpolationMethod;
			data.focalPointRatio = focalPointRatio;
			steps.push(data);
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			var data:Object = {};
			data.method = "LINE_GRADIENT_STYLE";
			data.type = type;
			data.colors = colors;
			data.alphas = alphas;
			data.ratios = ratios;
			data.matrix = matrix;
			data.spreadMethod = spreadMethod;
			data.interpolationMethod = interpolationMethod;
			data.focalPointRatio = focalPointRatio;
			steps.push(data);
		}
		
		public function endFill():void
		{
			var data:Object = {};
			data.method = "END_FILL";
			steps.push(data);
		}
		
		public function get jsonObject():String { return JSON.stringify(steps); }
	}
}