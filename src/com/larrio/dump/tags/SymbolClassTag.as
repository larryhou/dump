package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.utils.assertTrue;
	
	/**
	 * 链接名TAG
	 * @author larryhou
	 * @createTime Dec 16, 2012 2:29:28 PM
	 */
	public class SymbolClassTag extends SWFTag
	{
		public static const TYPE:uint = TagType.SYMBOL_CLASS;
		
		/**
		 * 构造函数
		 * create a [SymbolClassTag] object
		 */
		public function SymbolClassTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == SymbolClassTag.TYPE);
			
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