package com.larrio.dump.flash.display.shape.canvas
{
	import com.larrio.dump.utils.padding;
	
	import flash.display.BitmapData;
	import flash.display.InterpolationMethod;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Sep 4, 2015 10:48:57 PM
	 */
	public class SVGImageCanvas implements ICanvas
	{		
		private var _data:Vector.<String>;
		private var _gradIndex:uint;
		
		private var _image:XML;
		private var _path:XML;
		
		private var _bounds:Rectangle;
		private var _frame:Rectangle;
		
		/**
		 * 构造函数
		 * create a [SVGImageCanvas] object
		 */
		public function SVGImageCanvas(imageWidth:int = 1024, imageHeight:int = 768)
		{
			_frame = new Rectangle(0, 0, imageWidth, imageHeight);
			
			_image = new XML("<svg/>");
			_image.@version = "1.1";
			_image.@xmlns = "http://www.w3.org/2000/svg";
			
			_bounds = new Rectangle();
		}
		
		private function getRGBColor(color:uint):String
		{
			var b:String = padding((color >> 0  & 0xFF).toString(16), 2, "0", false);
			var g:String = padding((color >> 8  & 0xFF).toString(16), 2, "0", false);
			var r:String = padding((color >> 16 & 0xFF).toString(16), 2, "0", false);
			return "#" + r.toUpperCase() + g.toUpperCase() + b.toUpperCase();
		}
		
		public function export():String
		{
			flushContext();
			
			var rect:Rectangle = new Rectangle(_bounds.left, _bounds.top, _bounds.right - _bounds.left, _bounds.bottom - _bounds.top);
			
			_image.@["width"]  = _frame.width;
			_image.@["height"] = _frame.height;
			
			const MARGIN:Number = 20.0;
			var scale:Number = Math.min((_frame.width - MARGIN)/rect.width, (_frame.height - MARGIN) / rect.height);
			var translateX:Number = -(rect.x + rect.width  / 2) + _frame.width  / 2 / scale;
			var translateY:Number = -(rect.y + rect.height / 2) + _frame.height / 2 / scale;
			_image.g.@["transform"] = 
				"scale(" + scale.toFixed(2) + "," + scale.toFixed(2) + ") " +
				"translate(" + translateX.toFixed(2) + "," + translateY.toFixed(2) + ")";
			
			XML.prettyPrinting = true;
			XML.prettyIndent = 4;
			
			return _image.toXMLString();
		}
		
		private function flushContext():void
		{
			if (_path && _data)
			{
				if (_data.length)
				{
					_path.@["d"] = _data.join(" ");
					if (_image.g.length() == 0)
					{
						_image.appendChild(new XML("<g/>"));
					}
					
					_image.g.appendChild(_path);
				}
				_data = null;
			}
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			flushContext();
			
			_data = new Vector.<String>();
			
			_path = new XML("<path/>");
			_path.@["stroke"] = getRGBColor(color);
			_path.@["stroke-width"] = (thickness || 0).toFixed(2);
			_path.@["stroke-opacity"] = alpha.toFixed(2);
			_path.@["stroke-linecap"] = (!caps || caps == "none")? "butt" : caps;
			_path.@["stroke-linejoin"] = joints || "round";
			_path.@["stroke-miterlimit"] = miterLimit.toFixed(2);
			_path.@["fill"] = "transparent";
		}
		
		private function unitBoundsWithPoint(x:Number, y:Number):void
		{
			_bounds.left   = Math.min(x, _bounds.left);
			_bounds.right  = Math.max(x, _bounds.right);
			_bounds.top    = Math.min(y, _bounds.top);
			_bounds.bottom = Math.max(y, _bounds.bottom);
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			_data.push("M" + x.toFixed(2) + "," + y.toFixed(2));
			unitBoundsWithPoint(x, y);
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			_data.push("L" + x.toFixed(2) + "," + y.toFixed(2));
			unitBoundsWithPoint(x, y);
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void
		{
			_data.push("Q" + controlX.toFixed(2) + "," + controlY.toFixed(2) + " " + anchorX.toFixed(2) + "," + anchorY.toFixed(2));
			unitBoundsWithPoint(controlX, controlY);
			unitBoundsWithPoint(anchorX, anchorY);
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			flushContext();
			
			_data = new Vector.<String>();
			_path = new XML("<path/>");
			_path.@["fill"] = getRGBColor(color);
			_path.@["fill-opacity"] = alpha.toFixed(2);
		}
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void
		{
			beginFill(0xFF0000, 1.0);
		}
		
		private function createGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Number):String
		{
			matrix ||= new Matrix();
			
			var angle:Number = Math.atan2(matrix.b, matrix.a);
			var scaleX:Number = matrix.a / Math.cos(angle);
			var scaleY:Number = matrix.d / Math.cos(angle);
			var width:Number = scaleX * 1638.4, height:Number = scaleY * 1638.4;
			
			var gradient:XML;
			if (type == "radial")
			{
				gradient = new XML("<radialGradient/>");
				var radius:Number = Math.max(width / 2, height / 2);
				var focalPoint:Point = new Point(
					width  / 2 * Math.cos(angle) * focalPointRatio + matrix.tx,
					height / 2 * Math.sin(angle) * focalPointRatio + matrix.ty);
				var center:Point = new Point(matrix.tx, matrix.ty);
				gradient.@["cx"] = center.x.toFixed(2);
				gradient.@["cy"] = center.y.toFixed(2);
				gradient.@["fx"] = focalPoint.x.toFixed(2);
				gradient.@["fy"] = focalPoint.y.toFixed(2);
				gradient.@["r"] = radius.toFixed(2);
			}
			else
			{
				gradient = new XML("<linearGradient/>");
				var sp:Point = new Point(-819.2 * scaleX, 0);
				var startPoint:Point = new Point(
					sp.x * Math.cos(angle) - sp.y * Math.sin(angle) + matrix.tx,
					sp.x * Math.sin(angle) + sp.y * Math.cos(angle) + matrix.ty);
				var ep:Point = new Point( 819.2 * scaleX, 0);
				var endPoint:Point = new Point(
					ep.x * Math.cos(angle) - ep.y * Math.sin(angle) + matrix.tx,
					ep.x * Math.sin(angle) + ep.y * Math.cos(angle) + matrix.ty);
				gradient.@["x1"] = startPoint.x.toFixed(2);
				gradient.@["y1"] = startPoint.y.toFixed(2);
				gradient.@["x2"] = endPoint.x.toFixed(2);
				gradient.@["y2"] = endPoint.y.toFixed(2);
			}
			
			gradient.@["gradientUnits"] = "userSpaceOnUse";
			gradient.@["spreadMethod"] = spreadMethod || "pad";
			gradient.@["id"] = "G" + (++_gradIndex);
			for (var i:int = 0; i < colors.length; i++)
			{
				var stop:XML = new XML("<stop/>");
				stop.@["offset"] = (ratios[i] / 0xFF).toFixed(2);
				stop.@["stop-color"] = getRGBColor(colors[i]);
				stop.@["stop-opacity"] = alphas[i].toFixed(2);
				gradient.appendChild(stop);
			}
			if (_image.defs.length() == 0)
			{
				_image.prependChild(new XML("<defs/>"));
			}
			_image.defs.appendChild(gradient);
			return "url(#" + gradient.@id + ")";
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			flushContext();
			
			_data = new Vector.<String>();
			_path = new XML("<path/>");
			_path.@["fill"] = createGradientStyle.apply(null, arguments);
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void
		{
			flushContext();
			
			_data = new Vector.<String>();
			_path = new XML("<path/>");
			_path.@["stroke"] = createGradientStyle.apply(null, arguments);
			_path.@["fill"] = "transparent";
		}
		
		public function endFill():void
		{
			_data.push("Z");
			
			flushContext();
		}
	}
}