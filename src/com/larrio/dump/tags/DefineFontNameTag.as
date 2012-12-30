package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:44:21 PM
	 */
	public class DefineFontNameTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT_NAME;
		
		private var _font:uint;
		private var _name:String;
		private var _copyright:String;
		
		/**
		 * 构造函数
		 * create a [DefineFontNameTag] object
		 */
		public function DefineFontNameTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_font = decoder.readUI16();
			
			_name = decoder.readSTR();
			_copyright = decoder.readSTR();
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_font);
			
			encoder.writeSTR(_name);
			encoder.writeSTR(_copyright);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineFontName/>");
			result.@font = _font;
			result.@name = _name;
			result.@copyright = _copyright;
			return result.toXMLString();	
		}

		/**
		 * ID for this font to which this refers
		 */		
		public function get font():uint { return _font; }

		/**
		 * Name of the font. 
		 * For fonts starting as Type 1, this is the PostScript FullName. 
		 * For fonts starting in sfnt formats such as TrueType and OpenType, this is name ID 4, platform ID 1, language ID 0 (Full name, Mac OS, English).
		 */		
		public function get name():String { return _name; }

		/**
		 * Arbitrary string of copyright information
		 */		
		public function get copyright():String { return _copyright; }

	}
}