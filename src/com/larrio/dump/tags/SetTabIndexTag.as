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
		
		private var _depth:uint;
		private var _index:uint;
		
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
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == SetTabIndexTag.TYPE);
			
			_depth = decoder.readUI16();
			_index = decoder.readUI16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			encoder.writeUI16(_depth);
			encoder.writeUI16(_index);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<SetTabIndexTag/>");
			result.@depth = _depth;
			result.@index = _index;
			return result.toXMLString();	
		}

		/**
		 * 特征深度
		 */		
		public function get depth():uint { return _depth; }

		/**
		 * TAB顺序索引
		 */		
		public function get index():uint { return _index; }

		
	}
}