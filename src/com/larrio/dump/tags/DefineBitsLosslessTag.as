package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.colors.Pix15Color;
	import com.larrio.dump.model.colors.Pix24Color;
	import com.larrio.dump.model.colors.Pix8Color;
	import com.larrio.dump.model.colors.RGBColor;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.display.BitmapData;
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
		protected var _pixels:Vector.<RGBColor>;
		
		protected var _unzliblen:uint;
		
		protected var _data:BitmapData;
		
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
			_dict[_character] = this;
			
			_format = decoder.readUI8();
			_width = decoder.readUI16();
			_height = decoder.readUI16();
			
			var zlib:FileDecoder
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
			
			if (_format == 3)
			{
				length = _colorTableSize + 1;
				_colorTableRGBs = new Vector.<RGBColor>(length, true);
				for (i = 0; i < length; i++)
				{
					_colorTableRGBs[i] = new RGBColor();
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
			if (_format == 4)
			{
				_pixels = new Vector.<RGBColor>(size, true);
				for (i = 0; i < size; i++)
				{
					_pixels[i] = new Pix15Color();
					_pixels[i].decode(decoder);
				}
			}
			else
			if (_format == 5)
			{
				_pixels = new Vector.<RGBColor>(size, true);
				for (i = 0; i < size; i++)
				{
					_pixels[i] = new Pix24Color();
					_pixels[i].decode(decoder);
				}
			}
			
			assertTrue(decoder.bytesAvailable == 0);
			
			decodeImage();
		}
		
		/**
		 * 解析出位图数据
		 */		
		protected final function decodeImage():void
		{
			var row:uint = _height;
			var column:uint = _width;
			
			if (_format == 3)
			{
				if (column % 4 != 0)
				{
					column = Math.ceil(column / 4) * 4;
				}
			}
			
			_data =  new BitmapData(column, row, true, 0);
			_data.lock();
			
			var color:RGBColor;
			var locX:uint, locY:uint;
			
			while (locY < row)
			{
				locX = 0;
				while (locX < column)
				{
					color = _pixels[column * locY + locX];
					
					_data.setPixel32(locX, locY, color.value);
					
					locX++;
				}
				
				locY++;
			}
			
			_data.unlock();
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
			
			if (_format == 3)
			{
				encoder.writeUI8(_colorTableSize);
			}
			
			var length:uint, i:int;
			var size:uint = _width * _height;
			var zlib:FileEncoder = new FileEncoder();
			
			if (_format == 3)
			{
				length = _colorTableSize + 1;
				for (i = 0; i < length; i++)
				{
					_colorTableRGBs[i].encode(zlib);
				}
			}
			
			length = _pixels.length;
			for (i = 0; i < length; i++)
			{
				_pixels[i].encode(zlib);
			}
			
			if (_unzliblen > 0)
			{
				assertTrue(zlib.length == _unzliblen);
			}
			
			_compressed = true;
			
			zlib.compress();
			encoder.writeBytes(zlib);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "<DefineBitsLosslessTag/>";	
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
		 * Array of pixel colors. 
		 * Number of entries is BitmapWidth * BitmapHeight, subject to padding (see note above).
		 */		
		public function get pixels():Vector.<RGBColor> { return _pixels; }

		/**
		 * 无损图片位图数据
		 */		
		public function get data():BitmapData { return _data; }

	}
}