package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 远程调试开关TAG
	 * @author larryhou
	 * @createTime Nov 11, 2013 1:16:37 PM
	 */
	public class EnableTelemetryTag extends SWFTag
	{
		public static const TYPE:uint = TagType.ENABLE_TELEMETRY;
		
		private var _password:String;
		
		/**
		 * 构造函数
		 * create a [EnableTelemetryTag] object
		 */
		public function EnableTelemetryTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{			
			decoder.readUI16();
			if (decoder.bytesAvailable)
			{
				_password = decoder.readMultiByte(32, "utf-8");
			}
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(0);
			if (_password)
			{
				encoder.writeMultiByte(_password, "utf-8");
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
		 * HASH密码
		 */		
		public function get password():String { return _password; }
		public function set password(value:String):void
		{
			_password = value;
		}

	}
}