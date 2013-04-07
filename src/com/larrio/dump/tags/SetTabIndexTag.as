package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 5:22:12 PM
	 */
	public class SetTabIndexTag extends SWFTag
	{
		public static const TYPE:uint = TagType.SET_TABLE_INDEX;
		
		/**
		 * 特征深度
		 */
		public var depth:uint;
		
		/**
		 * TAB顺序索引
		 */	
		public var index:uint;
		
		/**
		 * 构造函数
		 * create a [SetTabIndexTag] object
		 */
		public function SetTabIndexTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			depth = decoder.readUI16();
			index = decoder.readUI16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(depth);
			encoder.writeUI16(index);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<SetTabIndexTag/>");
			result.@depth = depth;
			result.@index = index;
			return result.toXMLString();	
		}

	}
}