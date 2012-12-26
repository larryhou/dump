package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 1:10:27 AM
	 */
	public class ShowFrameTag extends SWFTag
	{
		public static const TYPE:uint = TagType.SHOW_FRAME;
		
		/**
		 * 构造函数
		 * create a [ShowFrameTag] object
		 */
		public function ShowFrameTag()
		{
			
		}
				
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ShowFrameTag/>");
			return result.toXMLString();
		}
	}
}