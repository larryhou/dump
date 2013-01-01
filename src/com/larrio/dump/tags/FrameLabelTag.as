package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 1:08:31 AM
	 */
	public class FrameLabelTag extends SWFTag
	{
		public static const TYPE:uint = TagType.FRAME_LABEL;
		
		private var _name:String;
		private var _anchor:int;
		
		/**
		 * 构造函数
		 * create a [FrameLabelTag] object
		 */
		public function FrameLabelTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_name = decoder.readSTR();
			
			_anchor = -1;
			if (decoder.length - decoder.position == 1)
			{
				_anchor = decoder.readUI8();
				assertTrue(_anchor == 1 || _anchor == 0);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeSTR(_name);
			
			if (_anchor == 0 || _anchor == 1)
			{
				encoder.writeUI8(_anchor);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<FrameLabelTag/>");
			result.@name = _name;
			
			return result.toXMLString();
		}

		/**
		 * 帧标签名字
		 */		
		public function get name():String { return _name; }
		public function set name(value:String):void
		{
			_name = value;
		}
	}
}