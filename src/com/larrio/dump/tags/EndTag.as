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
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "<EndTag/>";
		}
		
	}
}