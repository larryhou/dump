package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.fonts.ZoneRecord;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:40:08 PM
	 */
	public class DefineFontAlignZonesTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT_ALIGN_ZONES;
		
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
			super.decodeTag(decoder);
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			super.encodeTag(encoder);
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
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

	}
}