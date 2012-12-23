package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 4:41:20 PM
	 */
	public class ScriptLimitsTag extends SWFTag
	{
		public static const TYPE:uint = TagType.SCRIPT_LIMITS;
		
		private var _recursion:uint;
		private var _timeout:uint;
		
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
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == ScriptLimitsTag.TYPE);
			
			decoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			_recursion = decoder.readUI16();
			_timeout = decoder.readUI16();
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			encoder.writeUI16(_recursion);
			encoder.writeUI16(_timeout);
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ScriptLimitsTag/>");
			result.@MaxRecursionDepth = _recursion;
			result.@ScriptTimeoutSeconds = _timeout;
			return result.toXMLString();
		}

		/**
		 * 脚本最大递归深度
		 */		
		public function get recursion():uint { return _recursion; }

		/**
		 * 脚本最大运行时间：秒
		 */		
		public function get timeout():uint { return _timeout; }

		
	}
}