package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.ColorTransformRecord;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:27:35 PM
	 */
	public class DefineButtonCxformTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_BUTTON_CXFORM;
		
		private var _button:uint;
		private var _colorTransform:ColorTransformRecord;
		
		/**
		 * 构造函数
		 * create a [DefineButtonCxformTag] object
		 */
		public function DefineButtonCxformTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_button = decoder.readUI16();
			_colorTransform = new ColorTransformRecord();
			_colorTransform.decode(decoder);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_button);
			_colorTransform.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineButtonCxformTag/>");
			result.@button = _button;
			result.appendChild(new XML(_colorTransform.toString()));
			return result.toXMLString();	
		}

		/**
		 * Button ID for this information
		 */		
		public function get button():uint { return _button; }

		/**
		 * Character color transform
		 */		
		public function get colorTransform():ColorTransformRecord { return _colorTransform; }

	}
}