package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 7:54:45 PM
	 */
	public class DefineBitsTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_BITS;
		
		protected var _data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [DefineBitsTag] object
		 */
		public function DefineBitsTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_dict[_character] = this;
			
			_data = new ByteArray();
			decoder.readBytes(_data);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeBytes(_data);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var localName:String = getQualifiedClassName(this).split("::")[1];
			var result:XML = new XML("<" + localName + "/>");
			result.@character = _character;
			
			return result.toXMLString();	
		}

		/**
		 * JPEG compressed image
		 * 8.0版本之后表示JPEG图片的二进制数据，可以直接保存为JPEG图片
		 * 对于JPEG3、JPEG4则需要混合alpha通道才能正确展示
		 */		
		public function get data():ByteArray { return _data; }

	}
}