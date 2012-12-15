package com.larrio.dump
{
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * SWF编解码
	 * @author larryhou
	 * @createTime Dec 15, 2012 6:20:03 PM
	 */
	public class Codec
	{
		/**
		 * SWF字节编码器 
		 */		
		public var encoder:FileEncoder;
		
		/**
		 * SWF字节文件解码器 
		 */		
		public var decoder:FileDecoder;
		
	}
}