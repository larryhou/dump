package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	import flash.utils.ByteArray;
	
	/**
	 * 解析opcode指令
	 * @author larryhou
	 * @createTime Dec 17, 2012 1:36:53 PM
	 */
	public class OpcodeInfo implements ICodec
	{
		private var _bytes:ByteArray;
		
		/**
		 * 构造函数
		 * create a [OpcodeInfo] object
		 */
		public function OpcodeInfo()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}
	}
}