package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.utils.assertTrue;
	
	/**
	 * 文件属性TAG
	 * @author larryhou
	 * @createTime Dec 16, 2012 2:28:46 PM
	 */
	public class FileAttributesTag extends SWFTag
	{
		public static const TYPE:uint = TagType.FILE_ATTRIBUTES;
		
		/**
		 * 构造函数
		 * create a [FileAttributesTag] object
		 */
		public function FileAttributesTag()
		{
			
		}
				
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == FileAttributesTag.TYPE);
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