package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 3:03:08 PM
	 */
	public class RemoveObject2Tag extends RemoveObjectTag
	{
		public static const TYPE:uint = TagType.REMOVE_OBJECT2;
		
		/**
		 * 构造函数
		 * create a [RemoveObject2Tag] object
		 */
		public function RemoveObject2Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_depth = decoder.readUI16();
			
			trace(this);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_depth);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<RemoveObject2Tag/>");
			result.@depth = _depth;
			
			return result.toXMLString();	
		}
	}
}