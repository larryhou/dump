package com.larrio.dump.interfaces
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 编解码接口
	 * @author larryhou
	 * @createTime Dec 16, 2012 10:18:44 AM
	 */
	public interface ICodec
	{
		/**
		 * 二进制编码接口
		 * @param encoder	编码器
		 */		
		function encode(encoder:FileEncoder):void;
		
		/**
		 * 二进制解码接口
		 * @param decoder	解码器
		 */		
		function decode(decoder:FileDecoder):void;
	}
}