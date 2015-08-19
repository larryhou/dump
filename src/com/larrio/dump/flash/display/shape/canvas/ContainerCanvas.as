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
	public class ContainerCanvas implements ICanvas
	{
		private var _canvasVector:Vector.<ICanvas>;
		
		/**
		 * 构造函数
		 * create a [ContainerCanvas] object
		 */
		public function ContainerCanvas(list:Vector.<ICanvas> = null)
		{
			_canvasVector = list || new Vector.<ICanvas>();
		}
		
		public function addCanvas(canvas:ICanvas):Boolean
		{
			if (canvas && _canvasVector.indexOf(canvas) < 0)
			{
				_canvasVector.push(canvas);
				return true;
			}
			
			return false;
		}
		
		public function removeCanvas(canvas:ICanvas):ICanvas
		{
			var index:int;
			if (canvas && (index = _canvasVector.indexOf(canvas)) >= 0)
			{
				return _canvasVector.splice(index, 1)[0];
			}
			
			return null;
		}
		
		public function getCanvasByClass(cls:Class):Vector.<ICanvas>
		{
			var result:Vector.<ICanvas> = new Vector.<ICanvas>();
			for each(var canvas:ICanvas in _canvasVector)
			{
				if (canvas is cls)
				{
					result.push(canvas);
				}
			}
			return result;
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].lineStyle.apply(null, arguments);
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].moveTo.apply(null, arguments);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].lineTo.apply(null, arguments);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].curveTo.apply(null, arguments);
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].beginFill.apply(null, arguments);
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].beginBitmapFill.apply(null, arguments);
		}	
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].beginGradientFill.apply(null, arguments);
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].lineGradientStyle.apply(null, arguments);
		}
		
		public function endFill():void
		{
			for (var i:int = 0, length:uint = _canvasVector.length; i < length; i++) _canvasVector[i].endFill();
		}
	}
}