package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:10:46 PM
	 */
	public class DefineBitsJPEG3Tag extends DefineBitsJPEG2Tag
	{
		public static const TYPE:uint = TagType.DEFINE_BITS_JPEG3;
		
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
			_dict[_character] = this;
			
			_size = decoder.readUI32();
			
			_data = new ByteArray();
			decoder.readBytes(_data, 0, _size);
			
			_bitmapAlphaData = new ByteArray();
			decoder.readBytes(_bitmapAlphaData);
			
			_bitmapAlphaData.uncompress();
		}
		
		/**
		 * Alpha通道混合 
		 * @param data	JPEG位图BitmapData数据
		 * @param dispose	是否释放源BitmapData占用内存
		 */		
		public function blendAlpha(data:BitmapData, dispose:Boolean = true):BitmapData
		{
			data.lock();
			
			var result:BitmapData = new BitmapData(data.width, data.height, true, 0);
			result.lock();
			
			_bitmapAlphaData.position = 0;
			
			var alpha:uint;
			var locX:uint, locY:uint;
			while (locY < result.height)
			{
				locX = 0;
				while (locX < result.width)
				{
					alpha = _bitmapAlphaData.readUnsignedByte();
					result.setPixel32(locX, locY, alpha << 24 | data.getPixel(locX, locY));
					locX++;
				}
				
				locY++;
			}
			
			result.unlock();
			dispose && data.dispose();
			
			return result;
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
			
			_bitmapAlphaData.compress();
			_compressed = true;
			
			encoder.writeBytes(_bitmapAlphaData);
		}
		
		/**
		 * ZLIB compressed array of alpha data. Only supported when tag contains JPEG data. 
		 * One byte per pixel. Total size after decompression must equal (width * height) of JPEG image.
		 */		
		public function get bitmapAlphaData():ByteArray { return _bitmapAlphaData; }

	}
}