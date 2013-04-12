package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 2:59:03 PM
	 */
	public class RemoveObjectTag extends SWFTag
	{
		public static const TYPE:uint = TagType.REMOVE_OBJECT;
		
		/**
		 * Depth of character
		 */
		protected var depth:uint;
		
		/**
		 * 构造函数
		 * create a [RemoveObjectTag] object
		 */
		public function RemoveObjectTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			depth = decoder.readUI16();
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeUI16(depth);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<PlaceObjectTag/>");
			result.@character = _character;
			result.@depth = depth;
			return result.toXMLString();	
		}
		
		/**
		 * 需要移出显示列表的显示对象特征ID
		 */		
		public function set charactor(value:uint):void
		{
			_character = value;
		}

	}
}