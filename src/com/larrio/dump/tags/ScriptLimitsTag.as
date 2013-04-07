package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 脚本运行限制
	 * @author larryhou
	 * @createTime Dec 23, 2012 4:41:20 PM
	 */
	public class ScriptLimitsTag extends SWFTag
	{
		public static const TYPE:uint = TagType.SCRIPT_LIMITS;
		
		/**
		 * 脚本最大递归深度
		 */	
		public var recursion:uint;
		
		/**
		 * 脚本最大运行时间：秒
		 */	
		public var timeout:uint;
		
		/**
		 * 构造函数
		 * create a [ScriptLimitsTag] object
		 */
		public function ScriptLimitsTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			recursion = decoder.readUI16();
			timeout = decoder.readUI16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(recursion);
			encoder.writeUI16(timeout);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ScriptLimitsTag/>");
			result.@MaxRecursionDepth = recursion;
			result.@ScriptTimeoutSeconds = timeout;
			return result.toXMLString();
		}

	}
}