package com.larrio.dump.flash.display.shape.canvas
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Mar 29, 2013 11:57:37 AM
	 */
	public class FontCanvas implements ICanvas
	{
		private var _graphics:Graphics;
		
		/**
		 * 构造函数
		 * create a [FontCanvas] object
		 */
		public function FontCanvas(graphics:Graphics)
		{
			_graphics = graphics;
		}	
		
		public function moveTo(x:Number, y:Number):void
		{
			_graphics.moveTo.apply(null, arguments);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			_graphics.lineTo.apply(null, arguments);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_graphics.curveTo.apply(null, arguments);
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
		}

		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
		}	
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
		}
		
		public function endFill():void
		{
		}	
	}
}