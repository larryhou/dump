package com.larrio.dump.model.sound.mp3.id3.header
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 12:35:28 AM
	 */
	public class ID3ExtendHeader implements ICodec
	{
		/**
		 * 构造函数
		 * create a [ID3ExtendHeader] object
		 */
		public function ID3ExtendHeader()
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
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}
	}
}