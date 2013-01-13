package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.model.colors.RGBColor;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Graphics;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 1:50:49 PM
	 */
	public class LineStyle implements ICodec
	{
		protected var _shape:uint;
		protected var _width:uint;
		protected var _color:RGBColor;
		
		/**
		 * 构造函数
		 * create a [LineStyle] object
		 */
		public function LineStyle(shape:uint)
		{
			_shape = shape;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_width = decoder.readUI16();
			switch(_shape)
			{
				case TagType.DEFINE_SHAPE:
				case TagType.DEFINE_SHAPE2:
				{
					_color = new RGBColor();	
					break;
				}
					
				default:
				{
					_color = new RGBAColor();
					break;
				}
			}
			
			_color.decode(decoder);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI16(_width);
			_color.encode(encoder);
		}
		
		/**
		 * 更新Graphics的线条样式
		 */		
		public function changeStyle(canvas:Graphics):void
		{
			var alpha:Number = 1;
			if (_color is RGBAColor) alpha = (_color as RGBAColor).alpha / 0xFF;
			
			canvas.lineStyle(_width / 20, _color.rgb, alpha);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<LineStyle/>");
			result.@width = _width / 20;
			result.appendChild(new XML(_color.toString()));
			return result.toXMLString();	
		}

		/**
		 * Width of line in twips.
		 */		
		public function get width():uint { return _width; }

		/**
		 * Color value including channel information for Shape3.
		 * RGB (Shape1 or Shape2)
		 * alpha RGBA (Shape3)
		 */		
		public function get color():RGBColor { return _color; }

	}
}