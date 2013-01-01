package com.larrio.dump.model.text
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.colors.RGBColor;
	import com.larrio.dump.tags.DefineFontTag;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 1, 2013 1:55:33 PM
	 */
	public class TextRecord implements ICodec
	{
		private var _type:uint;
		private var _reserved:uint;
		
		private var _numgbits:uint;
		private var _numabits:uint;
		
		private var _hasFont:uint;
		private var _hasColor:uint;
		private var _hasOffsetY:uint;
		private var _hasOffsetX:uint;
		
		private var _font:uint;
		private var _color:RGBColor;
		private var _offsetY:uint;
		private var _offsetX:uint;
		
		private var _height:uint;
		
		private var _entries:Vector.<GlyphEntry>;
		
		/**
		 * 构造函数
		 * create a [TextRecord] object
		 */
		public function TextRecord(numgbits:uint, numabits:uint)
		{
			_numgbits = numgbits;
			_numabits = numabits;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_type = decoder.readUB(1);
			_reserved = decoder.readUB(3);
			
			_hasFont = decoder.readUB(1); 
			_hasColor = decoder.readUB(1);
			_hasOffsetY = decoder.readUB(1);
			_hasOffsetX = decoder.readUB(1);
			
			if (_hasFont)
			{
				_font = decoder.readUI16();
			}
			
			if (_hasColor)
			{
				_color = new RGBColor();
				_color.decode(decoder);
			}
			
			if (_hasOffsetX)
			{
				_offsetX = decoder.readS16();
			}
			
			if (_hasOffsetY)
			{
				_offsetY = decoder.readS16();
			}
			
			if (_hasFont)
			{
				_height = decoder.readUI16();
			}
			
			var length:uint = decoder.readUI8();
			
			_entries = new Vector.<GlyphEntry>(length, true);
			for (var i:int = 0; i < length; i++)
			{
				_entries[i] = new GlyphEntry(_numgbits, _numabits);
				_entries[i].decode(decoder);
			}	
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_type, 1);
			encoder.writeUB(_reserved, 3);
			
			encoder.writeUB(_hasFont, 1);
			encoder.writeUB(_hasColor, 1);
			encoder.writeUB(_hasOffsetY, 1);
			encoder.writeUB(_hasOffsetX, 1);
			
			if (_hasFont)
			{
				encoder.writeUI16(_font);
			}
			
			if (_hasColor)
			{
				_color.encode(encoder);
			}
			
			if (_hasOffsetX)
			{
				encoder.writeS16(_offsetX);
			}
			
			if (_hasOffsetY)
			{
				encoder.writeS16(_offsetY);
			}
			
			if (_hasFont)
			{
				encoder.writeUI16(_height);
			}
			
			var length:uint = _entries.length;
			encoder.writeUI8(length);
			
			for (var i:int = 0; i < length; i++)
			{
				_entries[i].encode(encoder);
			}
			
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<TextRecord/>");
			
			if (_hasFont) result.@font = _font;
			if (_hasOffsetX) result.@offsetX = _offsetX;
			if (_hasOffsetY) result.@offsetY = _offsetY;
			if (_hasFont) result.@height = _height;
			if (_hasColor) result.appendChild(new XML(_color.toString()));
			
			var length:uint = _entries.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_entries[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Font ID for following text.
		 */		
		public function get font():uint { return _font; }

		/**
		 * Font color for following text.
		 */		
		public function get color():RGBColor { return _color; }

		/**
		 * x offset for following text.
		 */		
		public function get offsetY():uint { return _offsetY; }

		/**
		 * y offset for following text.
		 */		
		public function get offsetX():uint { return _offsetX; }

		/**
		 * Font height for following text.
		 */		
		public function get height():uint { return _height; }

		/**
		 * Glyph entry
		 */		
		public function get entries():Vector.<GlyphEntry> { return _entries; }

	}
}