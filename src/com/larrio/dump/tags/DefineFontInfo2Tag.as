package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 4:02:45 PM
	 */
	public class DefineFontInfo2Tag extends DefineFontInfoTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT_INFO2;
		
		private var _langcode:uint;
		
		/**
		 * 构造函数
		 * create a [DefineFontInfo2Tag] object
		 */
		public function DefineFontInfo2Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_font = decoder.readUI16();
			
			var fontTag:DefineFontTag = _dict[_font] as DefineFontTag;
			fontTag.fontInfo = this;
			
			_name = decoder.readMultiByte(decoder.readUI8(), "UTF-8");
			
			assertTrue(decoder.readUB(2) == 0);
			
			_smallText = decoder.readUB(1);
			_shiftJIS = decoder.readUB(1);
			_ansi = decoder.readUB(1);
			_italic = decoder.readUB(1);
			_bold = decoder.readUB(1);
			_wideCodes = decoder.readUB(1);
			
			_langcode = decoder.readUI8();
			
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
			encoder.writeUI16(_font);
			
			var bytes:ByteArray;
			bytes = new ByteArray();
			bytes.writeMultiByte(_name, "UTF-8");
			encoder.writeUI8(bytes.length);
			encoder.writeBytes(bytes);
			
			encoder.writeUB(0, 2);
			encoder.writeUB(_smallText, 1);
			encoder.writeUB(_shiftJIS, 1);
			encoder.writeUB(_ansi, 1);
			encoder.writeUB(_italic, 1);
			encoder.writeUB(_bold, 1);
			encoder.writeUB(_wideCodes, 1);
			
			encoder.writeUI8(_langcode);
			
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
		override public function toString():String
		{
			var result:XML = new XML("<DefineFontInfo2Tag/>");
			result.@font = _font;
			result.@name = _name;
			result.@smallText = Boolean(_smallText);
			result.@shiftJIS = Boolean(_shiftJIS);
			result.@ANSI = Boolean(_ansi);
			result.@italic = Boolean(_italic);
			result.@bold = Boolean(_bold);
			result.@wideCodes = Boolean(_wideCodes);
			result.@langcode = _langcode;
			return result.toXMLString();	
		}

		/**
		 * Language ID.
		 */		
		public function get langcode():uint { return _langcode; }

	}
}
