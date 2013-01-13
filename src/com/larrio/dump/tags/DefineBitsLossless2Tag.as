package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.colors.ARGBColor;
	import com.larrio.dump.model.colors.Pix8Color;
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.model.colors.RGBColor;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 9:14:13 PM
	 */
	public class DefineBitsLossless2Tag extends DefineBitsLosslessTag
	{
		public static const TYPE:uint = TagType.DEFINE_BITS_LOSSLESS2;
		
		/**
		 * 构造函数
		 * create a [DefineBitsLossless2Tag] object
		 */
		public function DefineBitsLossless2Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_dict[_character] = this;
			
			_format = decoder.readUI8();
			_width = decoder.readUI16();
			_height = decoder.readUI16();
			
			var zlib:FileDecoder;
			var length:uint, i:int;
			var size:uint = _width * _height;
			
			if (_format == 3)
			{
				_colorTableSize = decoder.readUI8();
			}
			
			zlib = new FileDecoder();
			decoder.readBytes(zlib);
			zlib.uncompress();
			zlib.position = 0;
			decoder = zlib;
			
			_unzliblen = decoder.length;
			
			if (_format == 3)
			{
				length = _colorTableSize + 1;
				_colorTableRGBs = new Vector.<RGBColor>(length, true);
				for (i = 0; i < length; i++)
				{
					_colorTableRGBs[i] = new RGBAColor();
					_colorTableRGBs[i].decode(decoder);
				}
				
				if (_width % 4 != 0)
				{
					size = Math.ceil(_width / 4) * 4 * _height;
				}
				
				_pixels = new Vector.<RGBColor>(size);
				for (i = 0; i < size; i++)
				{
					_pixels[i] = new Pix8Color();
					_pixels[i].decode(decoder);
				}
			}
			else
			if (format == 4 || format == 5)
			{
				_pixels = new Vector.<RGBColor>(size, true);
				for (i = 0; i < size; i++)
				{
					_pixels[i] = new ARGBColor();
					_pixels[i].decode(decoder);
				}
			}
			
			assertTrue(decoder.bytesAvailable == 0);
			
			decodeImage();
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			super.encodeTag(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			return "<DefineBitsLossless2Tag/>";	
		}
	}
}