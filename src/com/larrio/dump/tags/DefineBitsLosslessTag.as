package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.colors.Pix15Color;
	import com.larrio.dump.model.colors.Pix24Color;
	import com.larrio.dump.model.colors.RGBColor;
	import com.larrio.dump.model.types.BitmapType;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:41:10 PM
	 */
	public class DefineBitsLosslessTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_BITS_LOSSLESS;
		
		protected var _format:uint;
		protected var _width:uint;
		protected var _height:uint;
		
		protected var _colorTableSize:uint;
		
		protected var _colorTableRGBs:Vector.<RGBColor>;
		protected var _colormapData:ByteArray;
		
		protected var _bitmapData:Vector.<RGBColor>;
		
		/**
		 * 构造函数
		 * create a [DefineBitsLosslessTag] object
		 */
		public function DefineBitsLosslessTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			
			_format = decoder.readUI8();
			_width = decoder.readUI16();
			_height = decoder.readUI16();
			
			var length:uint, i:int;
			var size:uint = _width * _height;
			
			if (_format == BitmapType.COLORMAP_8_BITS)
			{
				_colorTableSize = decoder.readUI8();
				
				length = _colorTableSize + 1;
				_colorTableRGBs = new Vector.<RGBColor>(length, true);
				for (i = 0; i < length; i++)
				{
					_colorTableRGBs[i] = new RGBColor();
					_colorTableRGBs[i].decode(decoder);
				}
				
				_colormapData = new ByteArray();
				decoder.readBytes(_colormapData, size);
			}
			else
			if (format == BitmapType.RGB_15_BITS)
			{
				_bitmapData = new Vector.<RGBColor>(size, true);
				for (i = 0; i < size; i++)
				{
					_bitmapData[i] = new Pix15Color();
					_bitmapData[i].decode(decoder);
				}
			}
			else
			if (format == BitmapType.RGB_24_BITS)
			{
				_bitmapData = new Vector.<Pix15Color>(size, true);
				for (i = 0; i < size; i++)
				{
					_bitmapData[i] = new Pix24Color();
					_bitmapData[i].decode(decoder);
				}
			}
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			encoder.writeUI8(_format);
			encoder.writeUI16(_width);
			encoder.writeUI16(_height);
			
			var length:uint, i:int;
			var size:uint = _width * _height;
			
			if (format == BitmapType.COLORMAP_8_BITS)
			{
				encoder.writeUI8(_colorTableSize);
				
				length = _colorTableSize + 1;
				for (i = 0; i < length; i++)
				{
					_colorTableRGBs[i].encode(encoder);
				}
				
				encoder.writeBytes(_colormapData);
			}
			else
			if (format == BitmapType.RGB_15_BITS || format == BitmapType.RGB_24_BITS)
			{
				length = size;
				for (i = 0; i < length; i++)
				{
					_bitmapData[i].encode(encoder);
				}
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}

		/**
		 * Format of compressed data 
		 * 3 = 8-bit colormapped image
		 * 4 = 15-bit RGB image 
		 * 5 = 24-bit RGB image
		 */		
		public function get format():uint { return _format; }

		/**
		 * Width of bitmap image
		 */		
		public function get width():uint { return _width; }

		/**
		 * Height of bitmap image
		 */		
		public function get height():uint { return _height; }

		/**
		 * This value is one less than the actual number of colors in the color table, allowing for up to 256 colors.
		 */		
		public function get colorTableSize():uint { return _colorTableSize; }

		/**
		 * Defines the mapping from color indices to RGB values. 
		 * Number of RGB values is BitmapColorTableSize + 1.
		 */		
		public function get colorTableRGBs():Vector.<RGBColor> { return _colorTableRGBs; }

		/**
		 * Array of color indices. 
		 * Number of entries is BitmapWidth * BitmapHeight, subject to padding (see note preceding this table).
		 */		
		public function get colormapData():ByteArray { return _colormapData; }

		/**
		 * Array of pixel colors. 
		 * Number of entries is BitmapWidth * BitmapHeight, subject to padding (see note above).
		 */		
		public function get bitmapData():Vector.<RGBColor> { return _bitmapData; }
	}
}