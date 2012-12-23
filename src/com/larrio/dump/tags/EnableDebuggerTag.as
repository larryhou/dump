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
		
		private var _password:String;
		
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
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == EnableDebuggerTag.TYPE);
			
			decoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			_password = "";
			if (decoder.bytesAvailable)
			{
				_password = decoder.readSTR();
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			if (_password)
			{
				encoder.writeSTR(_password);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}

		/**
		 * MD5加密过的密码
		 */		
		public function get password():String { return _password; }

		
	}
}