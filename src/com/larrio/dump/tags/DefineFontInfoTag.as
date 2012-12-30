package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 3:43:19 PM
	 */
	public class DefineFontInfoTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT_INFO;
		
		protected var _name:String;
		protected var _smallText:uint;
		protected var _shiftJIS:uint;
		protected var _ansi:uint;
		protected var _italic:uint;
		protected var _bold:uint;
		protected var _wideCodes:uint;
		protected var _codeTable:Vector.<uint>;
		
		/**
		 * 构造函数
		 * create a [DefineFontInfoTag] object
		 */
		public function DefineFontInfoTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			
			var fontTag:DefineFontTag = _map[_character] as DefineFontTag;
			fontTag.fontInfo = this;
				
			_name = decoder.readMultiByte(decoder.readUI8(), "UTF8");
			
			assertTrue(decoder.readUB(2) == 0);
			
			_smallText = decoder.readUB(1);
			_shiftJIS = decoder.readUB(1);
			_ansi = decoder.readUB(1);
			_italic = decoder.readUB(1);
			_bold = decoder.readUB(1);
			_wideCodes = decoder.readUB(1);
			
			_codeTable = new Vector.<uint>();
			if (_wideCodes)
			{
				while (decoder.bytesAvailable)
				{
					_codeTable.push(decoder.readUI16());
				}
			}
			else
			{
				while (decoder.bytesAvailable)
				{
					_codeTable.push(decoder.readUI8());
				}
			}
			
			trace(this);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			var bytes:ByteArray;
			bytes = new ByteArray();
			bytes.writeMultiByte(_name, "UTF8");
			encoder.writeUI8(bytes.length);
			encoder.writeBytes(bytes);
			
			encoder.writeUB(0, 2);
			encoder.writeUB(_smallText, 1);
			encoder.writeUB(_shiftJIS, 1);
			encoder.writeUB(_ansi, 1);
			encoder.writeUB(_italic, 1);
			encoder.writeUB(_bold, 1);
			encoder.writeUB(_wideCodes, 1);
			
			var length:uint = _codeTable.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_wideCodes)
				{
					encoder.writeUI16(_codeTable[i]);
				}
				else
				{
					encoder.writeUI8(_codeTable[i]);
				}
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineFontInfoTag/>");
			result.@character = _character;
			result.@name = _name;
			result.@smallText = Boolean(_smallText);
			result.@shiftJIS = Boolean(_shiftJIS);
			result.@ANSI = Boolean(_ansi);
			result.@italic = Boolean(_italic);
			result.@bold = Boolean(_bold);
			result.@wideCodes = Boolean(_wideCodes);
			return result.toXMLString();	
		}
		
		/**
		 * Name of the font 
		 */		
		public function get name():String { return _name; }

		/**
		 * Font is small. 
		 * Character glyphs are aligned on pixel boundaries for dynamic and input text.
		 */		
		public function get smallText():uint { return _smallText; }

		/**
		 * ShiftJIS character codes.
		 */		
		public function get shiftJIS():uint { return _shiftJIS; }

		/**
		 * ANSI character codes.
		 */		
		public function get ansi():uint { return _ansi; }

		/**
		 * Font is italic.
		 */		
		public function get italic():uint { return _italic; }

		/**
		 * Font is bold.
		 */		
		public function get bold():uint { return _bold; }

		/**
		 * If 1, CodeTable is UI16 array; otherwise, CodeTable is UI8 array.
		 */		
		public function get wideCodes():uint { return _wideCodes; }

	}
}