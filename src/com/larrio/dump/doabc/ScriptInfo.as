package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * DoABC之代码信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:43:37 PM
	 */
	public class ScriptInfo extends ClassInfo
	{
		/**
		 * 构造函数
		 * create a [ScriptInfo] object
		 */
		public function ScriptInfo(constants:ConstantPool)
		{
			super(constants);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			super.encode(encoder);
		}
	}
}