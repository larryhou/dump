package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:03:16 PM
	 */
	public class DefineShape3Tag extends DefineShape2Tag
	{
		public static const TYPE:uint = TagType.DEFINE_SHAPE3;
		
		/**
		 * 构造函数
		 * create a [DefineShape3Tag] object
		 */
		public function DefineShape3Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			super.decodeTag(decoder);
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			super.encodeTag(encoder);
			
		}
	}
}