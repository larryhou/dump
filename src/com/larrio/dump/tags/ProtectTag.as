package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 5:16:06 PM
	 */
	public class ProtectTag extends SWFTag
	{
		public static const TYPE:uint = TagType.PROTECT;
		
		/**
		 * MD5加密过的保护密码
		 */		
		public var password:String;
		
		/**
		 * 构造函数
		 * create a [ProtectTag] object
		 */
		public function ProtectTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			password = "";
			if (decoder.bytesAvailable)
			{
				password = decoder.readSTR();
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			if (password)
			{
				encoder.writeSTR(password);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ProtectTag/>");
			result.@password = password;
			return result;
		}
		
	}
}