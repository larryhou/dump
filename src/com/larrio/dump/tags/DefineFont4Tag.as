package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:22:22 PM
	 */
	public class DefineFont4Tag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT4;
		
		private var _hasFontData:uint;
		private var _italic:uint;
		private var _bold:uint;
		private var _name:String;
		private var _data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [DefineFont4Tag] object
		 */
		public function DefineFont4Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			
			assertTrue(decoder.readUB(5) == 0);
			
			_hasFontData = decoder.readUB(1);
			_italic = decoder.readUB(1);
			_bold = decoder.readUB(1);
			
			_name = decoder.readSTR();
			
			_data = new ByteArray();
			decoder.readBytes(_data);
			
			trace(this);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			encoder.writeUB(0, 5);
			encoder.writeUB(_hasFontData, 1);
			encoder.writeUB(_italic, 1);
			encoder.writeUB(_bold, 1);
			
			encoder.writeSTR(_name);
			encoder.writeBytes(_data);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineFont4Tag/>");
			result.@character = _character;
			result.@name = _name;
			result.@italic = Boolean(_italic);
			result.@bold = Boolean(_bold);
			return result.toXMLString();	
		}

		/**
		 * Italic font
		 */		
		public function get italic():uint { return _italic; }

		/**
		 * Bold font
		 */		
		public function get bold():uint { return _bold; }

		/**
		 * Name of the font.
		 */		
		public function get name():String { return _name; }

		/**
		 * When present, this is an OpenType CFF font, as defined in the OpenType specification at www.microsoft.com/ typography/otspec. 
		 * The following tables must be present: ‘CFF ’, ‘cmap’, ‘head’, ‘maxp’, ‘OS/2’, ‘post’, and either (a) ‘hhea’ and ‘hmtx’, or (b) ‘vhea’, ‘vmtx’, and ‘VORG’. 
		 * The ‘cmap’ table must include one of the following kinds of Unicode ‘cmap’ subtables: (0, 4), (0, 3), (3, 10), (3, 1), or (3, 0) [notation: (platform ID, platform- specific encoding ID)]. 
		 * Tables such as ‘GSUB’, ‘GPOS’, ‘GDEF’, and ‘BASE’ may also be present. 
		 * Only present for embedded fonts.
		 */		
		public function get data():ByteArray { return _data; }

	}
}