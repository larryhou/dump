package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 4:01:02 PM
	 */
	public class EndTag extends SWFTag
	{
		public static const TYPE:uint = TagType.END;
		
		/**
		 * 构造函数
		 * create a [EndTag] object
		 */
		public function EndTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == EndTag.TYPE);
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