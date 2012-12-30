package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.model.fonts.KerningRecord;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.dump.utils.hexSTR;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:15:49 PM
	 */
	public class DefineFont2Tag extends DefineFontTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT2;
		
		protected var _layout:uint;
		protected var _shiftJIS:uint;
		protected var _smallText:uint;
		protected var _ansi:uint;
		protected var _wideOffsets:uint;
		protected var _wideCodes:uint;
		protected var _italic:uint;
		protected var _bold:uint;
		
		protected var _langcode:uint;
		
		protected var _name:String;
		protected var _codeTableOffset:uint;
		protected var _codeTable:Vector.<uint>;
		
		protected var _ascent:uint;
		protected var _descent:uint;
		protected var _leading:uint;
		protected var _advanceTable:Vector.<int>;
		protected var _boundsTable:Vector.<SWFRect>;
		protected var _kerningRecords:Vector.<KerningRecord>;
		
		/**
		 * 构造函数
		 * create a [DefineFont2Tag] object
		 */
		public function DefineFont2Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_map[_character] = this;
			
			_layout = decoder.readUB(1);
			_shiftJIS = decoder.readUB(1);
			_smallText = decoder.readUB(1);
			_ansi = decoder.readUB(1);
			_wideOffsets = decoder.readUB(1);
			_wideCodes = decoder.readUB(1);
			_italic = decoder.readUB(1);
			_bold = decoder.readUB(1);
			decoder.byteAlign();
			
			_langcode = decoder.readUI8();
			
			_name = decoder.readMultiByte(decoder.readUI8(), "UTF8");
			
			var length:uint, i:int;
			length = decoder.readUI16();
			
			_offsetTable = new Vector.<uint>(length, true);
			if (_wideOffsets)
			{
				for (i = 0; i < length; i++) _offsetTable[i] = decoder.readUI32();
			}
			else
			{
				for (i = 0; i < length; i++) _offsetTable[i] = decoder.readUI16();
			}
			
			if (length > 0)
			{
				if (_wideOffsets)
				{
					_codeTableOffset = decoder.readUI32();
				}
				else
				{
					_codeTableOffset = decoder.readUI16();
				}
			}
			
			var size:uint;
			
			_glyphs = new Vector.<Shape>(length, true);
			for (i = 0; i < length; i++)
			{
				size = (i < length - 1)? (_offsetTable[i + 1] - _offsetTable[i]) : (_codeTableOffset - _offsetTable[i]);
				
				_glyphs[i] = new Shape(TagType.DEFINE_SHAPE3, size);
				_glyphs[i].decode(decoder);
			}
			
			_codeTable = new Vector.<uint>(length, true);
			if (_wideCodes)
			{
				 for (i = 0; i < length; i++) _codeTable[i] = decoder.readUI16();
			}
			else
			{
				for (i = 0; i < length; i++) _codeTable[i] = decoder.readUI8();
			}
			
			if (_layout)
			{
				_ascent = decoder.readS16();
				_descent = decoder.readS16();
				_leading = decoder.readS16();
				
				_advanceTable = new Vector.<int>(length, true);
				for (i = 0; i < length; i++)
				{
					_advanceTable[i] = decoder.readS16();
				}
				
				_boundsTable = new Vector.<SWFRect>(length, true);
				for (i = 0; i < length; i++)
				{
					_boundsTable[i] = new SWFRect();
					_boundsTable[i].decode(decoder);
				}
				
				length = decoder.readUI16();
				
				_kerningRecords = new Vector.<KerningRecord>(length, true);
				for (i = 0; i < length; i++)
				{
					_kerningRecords[i] = new KerningRecord(_wideCodes);
					_kerningRecords[i].decode(decoder);
				}
			}
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			encoder.writeUB(_layout, 1);
			encoder.writeUB(_shiftJIS, 1);
			encoder.writeUB(_smallText, 1);
			encoder.writeUB(_ansi, 1);
			encoder.writeUB(_wideOffsets, 1);
			encoder.writeUB(_wideCodes, 1);
			encoder.writeUB(_italic, 1);
			encoder.writeUB(_bold, 1);
			encoder.flush();
			
			encoder.writeUI8(_langcode);
			
			var bytes:ByteArray;
			bytes = new ByteArray();
			bytes.writeMultiByte(_name, "UTF8");
			bytes.writeByte(0);
			
			encoder.writeUI8(bytes.length);
			encoder.writeBytes(bytes);
			
			var length:uint, i:int;
			length = _offsetTable.length;
			
			encoder.writeUI16(length);
			if (_wideOffsets)
			{
				for (i = 0; i < length; i++) encoder.writeUI32(_offsetTable[i]);
			}
			else
			{
				for (i = 0; i < length; i++) encoder.writeUI16(_offsetTable[i]);
			}
			
			if (length > 0)
			{
				if (_wideOffsets)
				{
					encoder.writeUI32(_codeTableOffset);
				}
				else
				{
					encoder.writeUI16(_codeTableOffset);
				}
			}
			
			for (i = 0; i < length; i++)
			{
				_glyphs[i].encode(encoder);
			}
			
			if (_wideCodes)
			{
				for (i = 0; i < length; i++) encoder.writeUI16(_codeTable[i]);
			}
			else
			{
				for (i = 0; i < length; i++) encoder.writeUI8(_codeTable[i]);
			}
			
			if (_layout)
			{
				encoder.writeS16(_ascent); 
				encoder.writeS16(_descent);
				encoder.writeS16(_leading);
				
				for (i = 0; i < length; i++)
				{
					encoder.writeS16(_advanceTable[i]);
				}
				
				for (i = 0; i < length; i++)
				{
					_boundsTable[i].encode(encoder);
				}
				
				length = _kerningRecords.length;
				
				encoder.writeUI16(length);
				for (i = 0; i < length; i++)
				{
					_kerningRecords[i].encode(encoder);
				}
			}
		}
		
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var localName:String = getQualifiedClassName(this).split("::")[1];
			
			var result:XML = new XML("<" + localName + "/>");
			result.@character = _character;
			result.@name = _name;
			
			result.@numGlyphs = _glyphs.length;
			result.@shiftJIS = Boolean(_shiftJIS);
			result.@smallText = Boolean(_smallText);
			result.@ANSI = Boolean(_ansi);
			result.@italic = Boolean(_italic);
			result.@bold = Boolean(_bold);
			result.@langcode = _langcode;
			
			
			var item:XML;
			var length:uint, i:int;
			
			length = _glyphs.length;
			for (i = 0; i < length; i++)
			{
				item = new XML("<Glyph/>");
				item.@code = "0x" + _codeTable[i].toString(16).toUpperCase();
				item.@char = String.fromCharCode(_codeTable[i]);
				item.appendChild(new XML(_glyphs[i].toString()));
				result.appendChild(item);
			}
			
			if (_layout)
			{
				result.@ascent = _ascent;
				result.@descent = _descent;
				result.@leading = _leading;
				
				length = _kerningRecords.length;
				for (i = 0; i < length; i++)
				{
					result.appendChild(new XML(_kerningRecords[i].toString()));
				}
			}
			
			return result.toXMLString();	
		}

		/**
		 * Has font metrics/layout information.
		 */		
		public function get layout():uint { return _layout; }

		/**
		 * ShiftJIS encoding.
		 */		
		public function get shiftJIS():uint { return _shiftJIS; }

		/**
		 * Font is small. Character glyphs are aligned on pixel boundaries for dynamic and input text.
		 */		
		public function get smallText():uint { return _smallText; }

		/**
		 * ANSI encoding.
		 */		
		public function get ansi():uint { return _ansi; }

		/**
		 * If 1, uses 32 bit offsets.
		 */		
		public function get wideOffsets():uint { return _wideOffsets; }

		/**
		 * If 1, font uses 16-bit codes; otherwise font uses 8 bit codes.
		 */		
		public function get wideCodes():uint { return _wideCodes; }

		/**
		 * Italic Font.
		 */		
		public function get italic():uint { return _italic; }

		/**
		 * Bold Font.
		 */		
		public function get bold():uint { return _bold; }

		/**
		 * language code
		 */		
		public function get langcode():uint { return _langcode; }

		/**
		 * Name of font 
		 */		
		public function get name():String { return _name; }

	}
}