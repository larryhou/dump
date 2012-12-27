package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:10:46 PM
	 */
	public class DefineBitsJPEG3Tag extends DefineBitsJPEG2Tag
	{
		public static const TYPE:uint = TagType.DEFINE_BITSJPEG3;
		
		protected var _size:uint;
		protected var _bitmapAlphaData:ByteArray;
		
		/**
		 * 构造函数
		 * create a [DefineBitsJPEG3Tag] object
		 */
		public function DefineBitsJPEG3Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			
			_size = decoder.readUI32();
			
			_data = new ByteArray();
			decoder.readBytes(_data, 0, _size);
			
			_bitmapAlphaData = new ByteArray();
			decoder.readBytes(_bitmapAlphaData);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeUI32(_size);
			encoder.writeBytes(_data);
			encoder.writeBytes(_bitmapAlphaData);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			return "";	
		}

		/**
		 * ZLIB compressed array of alpha data. Only supported when tag contains JPEG data. 
		 * One byte per pixel. Total size after decompression must equal (width * height) of JPEG image.
		 */		
		public function get bitmapAlphaData():ByteArray { return _bitmapAlphaData; }

	}
}