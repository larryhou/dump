package com.larrio.dump.flash.display.shape
{
	import flash.display.BitmapData;
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	/**
	 * 虚拟canvas
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:33:21 PM
	 */
	public class GhostCanvas implements ICanvas
	{
		/**
		 * 构造函数
		 * create a [GhostCanvas] object
		 */
		public function GhostCanvas()
		{
			
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
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