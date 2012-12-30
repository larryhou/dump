package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.fonts.ZoneRecord;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:40:08 PM
	 */
	public class DefineFontAlignZonesTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT_ALIGN_ZONES;
		
		private var _font:uint;
		private var _csmTableHint:uint;
		private var _zoneTable:Vector.<ZoneRecord>;
		
		/**
		 * 构造函数
		 * create a [DefineFontAlignZonesTag] object
		 */
		public function DefineFontAlignZonesTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_font = decoder.readUI16();
			
			_csmTableHint = decoder.readUB(2);
			assertTrue(decoder.readUB(6) == 0);
			
			var fontTag:DefineFont3Tag = _map[_font] as DefineFont3Tag;
			var length:uint = fontTag.glyphs.length;
			
			_zoneTable = new Vector.<ZoneRecord>(length, true);
			for (var i:int = 0; i < length; i++)
			{
				_zoneTable[i] = new ZoneRecord();
				_zoneTable[i].decode(decoder);
			}
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_font);
			encoder.writeUB(_csmTableHint, 2);
			encoder.writeUB(0, 6);
			
			var length:uint = _zoneTable.length;
			for (var i:int = 0; i < length; i++)
			{
				_zoneTable[i].encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineFontAlignZone/>");
			result.@font = _font;
			result.@CSMTableHint = _csmTableHint;
			
			var length:uint = _zoneTable.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_zoneTable[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Font thickness hint. Refers to the thickness of the typical stroke used in the font. 
		 * 0 = thin
		 * 1 = medium
		 * 2 = thick
		 * Flash Player maintains a selection of CSM tables for many fonts. 
		 * However, if the font is not found in Flash Player's internal table, this hint is used to choose an appropriate table.
		 */		
		public function get csmTableHint():uint { return _csmTableHint; }

		/**
		 * Alignment zone information for each glyph.
		 */		
		public function get zoneTable():Vector.<ZoneRecord> { return _zoneTable; }

		/**
		 * ID of font to use, specified by DefineFont3.
		 */		
		public function get font():uint { return _font; }

	}
}