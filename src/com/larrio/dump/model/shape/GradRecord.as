package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.model.colors.RGBColor;
	import com.larrio.dump.tags.TagType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 10:38:55 PM
	 */
	public class GradRecord implements ICodec
	{
		private var _shape:uint;
		
		private var _ratio:uint;
		private var _color:RGBColor;
		
		/**
		 * 构造函数
		 * create a [GradRecord] object
		 */
		public function GradRecord(shape:uint)
		{
			_shape = shape;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_ratio = decoder.readUI8();
			switch(_shape)
			{
				case TagType.DEFINE_SHAPE:
				case TagType.DEFINE_SHAPE2:
				{
					_color = new RGBColor();
					break;
				}
					
				case TagType.DEFINE_SHAPE3:
				case TagType.DEFINE_SHAPE4:
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
			encoder.writeUI8(_ratio);
			_color.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<GradRecord/>");
			result.@ratio = _ratio / 0xFF;
			result.appendChild(new XML(_color.toString()));
			return result;	
		}

		/**
		 * Ratio value
		 */		
		public function get ratio():uint { return _ratio; }

		/**
		 * Color of gradient
		 * RGB (Shape1 or Shape2) 
		 * RGBA (Shape3 or Shape4)
		 */		
		public function get color():RGBColor { return _color; }

	}
}