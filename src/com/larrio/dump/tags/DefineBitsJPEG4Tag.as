package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 10:07:34 PM
	 */
	public class DefineBitsJPEG4Tag extends DefineBitsJPEG3Tag
	{
		public static const TYPE:uint = TagType.DEFINE_BITS_JPEG4;
		
		private var _deblockParam:uint;
		
		/**
		 * 构造函数
		 * create a [DefineBitsJPEG4Tag] object
		 */
		public function DefineBitsJPEG4Tag()
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
			
			_size = decoder.readUI32();
			_deblockParam = decoder.readUI16();
			
			_data = new ByteArray();
			decoder.readBytes(_data, 0, _size);
			
			_bitmapAlphaData = new ByteArray();
			decoder.readBytes(_bitmapAlphaData);
			
			_bitmapAlphaData.uncompress();
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeUI32(_size);
			encoder.writeUI16(_deblockParam);
			encoder.writeBytes(_data);
			
			_bitmapAlphaData.compress();
			_compressed = true;
			
			encoder.writeBytes(_bitmapAlphaData);
		}
		
		/**
		 * Parameter to be fed into the deblocking filter. 
		 * The parameter describes a relative strength of the deblocking filter from 0- 100% expressed in a normalized 8.8 fixed point format.
		 */		
		public function get deblockParam():uint { return _deblockParam; }

	}
}