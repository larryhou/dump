package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.net.Responder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 5:31:43 PM
	 */
	public class EnableDebugger2Tag extends SWFTag
	{
		public static const TYPE:uint = TagType.ENABLE_DEBUGGER2;
		
		/**
		 * MD5加密过的密码
		 */		
		public var password:String;
		
		/**
		 * Adobe保留字段 
		 */		
		public var reserved:uint;
		
		/**
		 * 构造函数
		 * create a [EnableDebugger2Tag] object
		 */
		public function EnableDebugger2Tag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			reserved = decoder.readUI16();
			password = decoder.readSTR();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(reserved);
			encoder.writeSTR(password);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<EnableDebugger2Tag/>");
			result.@password = password;
			return result.toXMLString();	
		}

	}
}