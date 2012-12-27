package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:01:21 PM
	 */
	public class JPEGTablesTag extends SWFTag
	{
		public static const TYPE:uint = TagType.JPEG_TABLES;
		
		private var _data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [JPEGTablesTag] object
		 */
		public function JPEGTablesTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_data = new ByteArray();
			
			decoder.readBytes(_data);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeBytes(_data);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}

		/**
		 * JPEG encoding table
		 */		
		public function get data():ByteArray { return _data; }

	}
}