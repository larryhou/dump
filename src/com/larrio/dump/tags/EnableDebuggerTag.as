package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 5:27:23 PM
	 */
	public class EnableDebuggerTag extends SWFTag
	{
		public static const TYPE:uint = TagType.ENABLE_DEBUGGER;
		
		/**
		 * MD5加密过的密码
		 */
		public var password:String;
		
		/**
		 * 构造函数
		 * create a [EnableDebuggerTag] object
		 */
		public function EnableDebuggerTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			password = decoder.readSTR();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeSTR(password);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<EnableDebuggerTag/>");
			result.@password = password;
			return result.toXMLString();	
		}
		
	}
}