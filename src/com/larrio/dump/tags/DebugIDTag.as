package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 9, 2013 5:35:06 PM
	 */
	public class DebugIDTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEBUG_ID;
		
		private var _data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [DebugIDTag] object
		 */
		public function DebugIDTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_data = new ByteArray();
			decoder.readBytes(_data, 0, 16);
			
			assertTrue(decoder.bytesAvailable == 0);
			
			trace(this);
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
			_data.position = 0;
			
			var uuid:String = "";
			
			var zero:uint = ("0").charCodeAt(0);
			var A:uint = ("A").charCodeAt(0);
			
			var byte:uint;
			var h:uint, l:uint;
			while (_data.bytesAvailable)
			{
				byte = _data.readUnsignedByte();
				h = (byte & 0xF0) >> 4;
				l = (byte & 0x0F);
				
				uuid += String.fromCharCode(h > 9? A + h - 10 : zero + h);
				uuid += String.fromCharCode(l > 9? A + l - 10 : zero + l);
			}
			
			var result:XML = new XML("<DebugIDTag/>");
			result.@UUID = uuid;
			
			return result.toXMLString();	
		}

		/**
		 * 16字节32个字符
		 */		
		public function get data():ByteArray { return _data; }

	}
}