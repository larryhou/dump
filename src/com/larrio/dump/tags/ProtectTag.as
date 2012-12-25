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
		
		private var _password:String;
		
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
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == ProtectTag.TYPE);
			
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
			var result:XML = new XML("<ProtectTag/>");
			result.@password = _password;
			return result;
		}

		/**
		 * MD5加密过的保护密码
		 */		
		public function get password():String { return _password; }

		
	}
}