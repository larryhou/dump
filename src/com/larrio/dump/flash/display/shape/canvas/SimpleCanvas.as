package com.larrio.dump.flash.display.shape.canvas
{
	import flash.display.BitmapData;
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	/**
	 * 用来收集API数据
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:33:21 PM
	 */
	public class SimpleCanvas implements ICanvas
	{
		private var _result:Array;
		
		/**
		 * 构造函数
		 * create a [GhostCanvas] object
		 */
		public function SimpleCanvas()
		{
			_result = [];
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			_result.push({method: "lineStyle", params: arguments});
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			_result.push({method: "moveTo", params: arguments});
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			_result.push({method: "lineTo", params: arguments});
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_result.push({method: "curveTo", params: arguments});
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			_result.push({method: "beginFill", params: arguments});
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			_result.push({method: "beginBitmapFill", params: arguments});
		}	
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			_result.push({method: "beginGradientFill", params: arguments});
		}
		
		public function endFill():void
		{
			_result.push({method: "endFill", params: arguments});
		}

		/**
		 * 绘画API数据列表
		 * @usage	{method: "moveTo", params: [1, 3]}
		 * @example	DisplayObject.graphics[item.method].applay(null, item.params);
		 */		
		public function get result():Array { return _result; }

	}
}