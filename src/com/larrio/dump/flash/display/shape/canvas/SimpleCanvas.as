package com.larrio.dump.flash.display.shape.canvas
{
	import flash.display.BitmapData;
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 用来收集API数据
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:33:21 PM
	 */
	public class SimpleCanvas implements ICanvas
	{
		private var _steps:Array;
		private var _bounds:Rectangle;
		
		/**
		 * 构造函数
		 * create a [GhostCanvas] object
		 */
		public function SimpleCanvas()
		{
			_steps = [];
			_bounds = new Rectangle()
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			_steps.push({method: "lineStyle", params: [thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit]});
			trace("graphics.lineStyle(" 
				+ thickness + ","
				+ "0x" + color.toString(16).toUpperCase() + ","
				+ alpha + ","
				+ pixelHinting + ","
				+ encodeStringValue(scaleMode) + ","
				+ encodeStringValue(caps) + ","
				+ encodeStringValue(joints) + ","
				+ miterLimit
				+ ");");
		}
		
		private function encodeStringValue(str:String):String
		{
			return str? "'" + str + "'" : 'null';
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			_steps.push({method: "moveTo", params: [x, y]});
			trace("graphics.moveTo(" + [x, y].join(",") + ");");
			caculateShapeBounds(x, y);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			_steps.push({method: "lineTo", params: [x, y]});
			trace("graphics.lineTo(" + [x, y].join(",") + ");");
			caculateShapeBounds(x, y);
		}
		
		private function caculateShapeBounds(x:Number, y:Number):void
		{
			_bounds.left   = Math.min(x, _bounds.left);
			_bounds.right  = Math.max(x, _bounds.right);
			_bounds.top    = Math.min(y, _bounds.top);
			_bounds.bottom = Math.max(y, _bounds.bottom);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_steps.push({method: "curveTo", params: [controlX, controlY, anchorX, anchorY]});
			trace("graphics.curveTo(" + [controlX, controlY, anchorX, anchorY].join(",") + ");");
			caculateShapeBounds(controlX, controlY);
			caculateShapeBounds(anchorX, anchorY);
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			_steps.push({method: "beginFill", params: [color, alpha]});
			trace("graphics.beginFill(0x" + color.toString(16).toUpperCase() + "," + alpha + ");");
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			_steps.push({method: "beginBitmapFill", params: arguments});
		}	
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			_steps.push({method: "beginGradientFill", params: [type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio]});
			trace("graphics.beginGradientFill(" 
				+ encodeStringValue(type) + ","
				+ "[" + colors.map(function(c:Number, ...args):String {return "0x" + c.toString(16).toUpperCase()}).join(",") + "],"
				+ JSON.stringify(alphas) + ","
				+ JSON.stringify(ratios) + ","
				+ (matrix? "new Matrix(" + [matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx,matrix.ty].join(",") + ")" : "null") + ","
				+ encodeStringValue(spreadMethod) + ","
				+ encodeStringValue(interpolationMethod) + ","
				+ focalPointRatio + ");");
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			_steps.push({method: "lineGradientStyle", params: [type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio]});
			trace("graphics.lineGradientStyle(" 
				+ encodeStringValue(type) + ","
				+ "[" + colors.map(function(c:Number, ...args):String {return "0x" + c.toString(16).toUpperCase()}).join(",") + "],"
				+ JSON.stringify(alphas) + ","
				+ JSON.stringify(ratios) + ","
				+ (matrix? "new Matrix(" + [matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx,matrix.ty].join(",") + ")" : "null") + ","
				+ encodeStringValue(spreadMethod) + ","
				+ encodeStringValue(interpolationMethod) + ","
				+ focalPointRatio + ");");
		}
		
		public function endFill():void
		{
			_steps.push({method: "endFill", params: []});
			trace("graphics.endFill();");
		}

		/**
		 * 绘画API数据列表
		 * @usage	{method: "moveTo", params: [1, 3]}
		 * @example	DisplayObject.graphics[item.method].applay(null, item.params);
		 */		
		public function get steps():Array { return _steps; }

		/**
		 * 矢量图绘画空间
		 */		
		public function get bounds():Rectangle { return _bounds; }
	}
}