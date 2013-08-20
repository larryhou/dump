package com.larrio.dump.flash.display.shape.canvas
{
	import flash.display.BitmapData;
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	
	/**
	 * canvas容器
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:43:55 PM
	 */
	public class CanvasContainer implements ICanvas
	{
		private var _list:Vector.<ICanvas>;
		
		/**
		 * 构造函数
		 * create a [CanvasContainer] object
		 */
		public function CanvasContainer(list:Vector.<ICanvas>)
		{
			_list = list;
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].lineStyle.apply(null, arguments);
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].moveTo.apply(null, arguments);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].lineTo.apply(null, arguments);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].curveTo.apply(null, arguments);
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].beginFill.apply(null, arguments);
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].beginBitmapFill.apply(null, arguments);
		}	
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].beginGradientFill.apply(null, arguments);
		}
		
		public function endFill():void
		{
			for (var i:int = 0, len:uint = _list.length; i < len; i++) _list[i].endFill();
		}

	}
}