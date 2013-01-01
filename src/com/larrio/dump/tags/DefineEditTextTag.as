package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.model.colors.RGBAColor;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:19:08 PM
	 */
	public class DefineEditTextTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_EDIT_TEXT;
		
		private var _bounds:SWFRect;
		
		private var _hasText:uint;
		private var _wordWrap:uint;
		private var _multiline:uint;
		private var _password:uint;
		private var _readOnly:uint;
		private var _hasTextColor:uint;
		private var _hasMaxLength:uint;
		private var _hasFont:uint;
		private var _hasFontClass:uint;
		private var _autoSize:uint;
		private var _hasLayout:uint;
		private var _unselectable:uint;
		private var _border:uint;
		private var _staticText:uint;
		private var _html:uint;
		private var _useOutlines:uint;
		
		private var _font:uint;
		private var _fontClass:String;
		private var _fontHeight:uint;
		private var _textColor:RGBAColor;
		private var _maxLength:uint;
		private var _align:uint;
		private var _leftMargin:uint;
		private var _rightMargin:uint;
		private var _indent:uint;
		private var _leading:int;
		
		private var _name:String;
		private var _text:String;
		
		/**
		 * 构造函数
		 * create a [DefineEditTextTag] object
		 */
		public function DefineEditTextTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			
			_bounds = new SWFRect();
			_bounds.decode(decoder);
			
			decoder.byteAlign();
			
			_hasText = decoder.readUB(1);
			_wordWrap = decoder.readUB(1);
			_multiline = decoder.readUB(1);
			_password = decoder.readUB(1);
			_readOnly = decoder.readUB(1);
			_hasTextColor = decoder.readUB(1);
			_hasMaxLength = decoder.readUB(1);
			_hasFont = decoder.readUB(1);
			
			_hasFontClass = decoder.readUB(1);
			_autoSize = decoder.readUB(1);
			_hasLayout = decoder.readUB(1);
			_unselectable = decoder.readUB(1);
			_border = decoder.readUB(1);
			_staticText = decoder.readUB(1);
			_html = decoder.readUB(1);
			_useOutlines = decoder.readUB(1);
			
			if (_hasFont)
			{
				_font = decoder.readUI16();
			}
			
			if (_hasFontClass)
			{
				_fontClass = decoder.readSTR();
			}
			
			if (_hasFont)
			{
				_fontHeight = decoder.readUI16();
			}
			
			if (_hasTextColor)
			{
				_textColor = new RGBAColor();
				_textColor.decode(decoder);
			}
			
			if (_hasMaxLength)
			{
				_maxLength = decoder.readUI16();
			}
			
			if (_hasLayout)
			{
				_align = decoder.readUI8();
				_leftMargin = decoder.readUI16();
				_rightMargin = decoder.readUI16();
				_indent = decoder.readUI16();
				_leading = decoder.readS16();
			}
			
			_name = decoder.readSTR();
			
			if (_hasText)
			{
				_text = decoder.readSTR();
			}
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			_bounds.encode(encoder);
			encoder.flush();
			
			encoder.writeUB(_hasText, 1);
			encoder.writeUB(_wordWrap, 1);
			encoder.writeUB(_multiline, 1);
			encoder.writeUB(_password, 1);
			encoder.writeUB(_readOnly, 1);
			encoder.writeUB(_hasTextColor, 1);
			encoder.writeUB(_hasMaxLength, 1);
			encoder.writeUB(_hasFont, 1);
			
			encoder.writeUB(_hasFontClass, 1);
			encoder.writeUB(_autoSize, 1);
			encoder.writeUB(_hasLayout, 1);
			encoder.writeUB(_unselectable, 1);
			encoder.writeUB(_border, 1);
			encoder.writeUB(_staticText, 1);
			encoder.writeUB(_html, 1);
			encoder.writeUB(_useOutlines, 1);
			
			if (_hasFont)
			{
				encoder.writeUI16(_font);
			}
			
			if (_hasFontClass)
			{
				encoder.writeSTR(_fontClass);
			}
			
			if (_hasFont)
			{
				encoder.writeUI16(_fontHeight);
			}
			
			if (_hasTextColor)
			{
				_textColor.encode(encoder);
			}
			
			if (_hasMaxLength)
			{
				encoder.writeUI16(_maxLength);
			}
			
			if (_hasLayout)
			{
				encoder.writeUI8(_align);
				encoder.writeUI16(_leftMargin);
				encoder.writeUI16(_rightMargin);
				encoder.writeUI16(_indent);
				encoder.writeS16(_leading);
			}
			
			encoder.writeSTR(_name);
			
			if (_hasText)
			{
				encoder.writeSTR(_text);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineEditTextTag/>");
			result.@character = _character;
			result.@name = _name;
			if (_hasFont) result.@font = _font;
			
			result.@wordWrap = Boolean(_wordWrap);
			result.@multiline = Boolean(_multiline);
			result.@password = Boolean(_password);
			result.@readOnly = Boolean(_readOnly);
			result.@autoSize = Boolean(_autoSize);
			result.@selectable = !Boolean(_unselectable);
			result.@border = Boolean(_border);
			result.@static = Boolean(_staticText);
			result.@HTML = Boolean(_html);
			result.@useOutlines = Boolean(_useOutlines);
			if (_hasFontClass) result.@fontClass = _fontClass;
			if (_hasFont) result.@fontHeight = _fontHeight;
			result.@maxLength = _maxLength;
			if (_hasLayout)
			{
				result.@align = _align;
				result.@leftMargin = _leftMargin;
				result.@rightMargin = _rightMargin;
				result.@indent = _indent;
				result.@leading = _leading;
			}
			
			result.appendChild(new XML(_bounds.toString()));
			if (_hasTextColor)
			{
				result.appendChild(new XML(_textColor.toString()));
			}
			
			result.appendChild(new XML("<Text>" + _text.replace(/\r/gm, "\\r").replace(/\t/g, "\\t") + "</Text>"));
			
			return result.toXMLString();	
		}

		/**
		 * Rectangle that completely encloses the text field.
		 */		
		public function get bounds():SWFRect { return _bounds; }

		/**
		 * 0 = text will not wrap and will scroll sideways.
		 * 1 = text will wrap automatically when the end of line is reached.
		 */		
		public function get wordWrap():uint { return _wordWrap; }

		/**
		 * 0 = text field is one line only. 
		 * 1 = text field is multi-line and scrollable.
		 */		
		public function get multiline():uint { return _multiline; }

		/**
		 * 0 = characters are displayed as typed.
		 * 1 = all characters are displayed as an asterisk.
		 */		
		public function get password():uint { return _password; }

		/**
		 * 0 = text editing is enabled. 
		 * 1 = text editing is disabled.
		 */		
		public function get readOnly():uint { return _readOnly; }

		/**
		 * Causes a border to be drawn around the text field.
		 */	
		public function get border():uint { return _border; }

		/**
		 * 0 = fixed size.
		 * 1 = sizes to content (SWF 6 or later only).
		 */	
		public function get autoSize():uint { return _autoSize; }

		/**
		 * 0 = plaintext content.
		 * 1 = HTML content (see following).
		 */		
		public function get html():uint { return _html; }

		/**
		 * 0 = use device font. 
		 * 1 = use glyph font.
		 */		
		public function get useOutlines():uint { return _useOutlines; }

		/**
		 * ID of font to use.
		 */		
		public function get font():uint { return _font; }

		/**
		 * Class name of font to be loaded from another SWF and used for this text.
		 */		
		public function get fontClass():String { return _fontClass; }

		/**
		 * Height of font in twips.
		 */		
		public function get fontHeight():uint { return _fontHeight; }

		/**
		 * Color of text.
		 */		
		public function get textColor():RGBAColor { return _textColor; }

		/**
		 * Text is restricted to this length.
		 */		
		public function get maxLength():uint { return _maxLength; }

		/**
		 * 0 = Left
		 * 1 = Right 
		 * 2 = Center 
		 * 3 = Justify
		 */		
		public function get align():uint { return _align; }

		/**
		 * Left margin in twips.
		 */		
		public function get leftMargin():uint { return _leftMargin; }

		/**
		 * Right margin in twips.
		 */		
		public function get rightMargin():uint { return _rightMargin; }

		/**
		 * Indent in twips.
		 */		
		public function get indent():uint { return _indent; }

		/**
		 * Leading in twips (vertical distance between bottom of descender of one line and top of ascender of the next).
		 */		
		public function get leading():uint { return _leading; }

		/**
		 * Name of the variable where the contents of the text field are stored. 
		 * May be qualified with dot syntax or slash syntax for non-global variables.
		 */		
		public function get name():String { return _name; }

		/**
		 * Text that is initially displayed.
		 */		
		public function get text():String { return _text; }

		/**
		 * Enables or disables interactive text selection.
		 */		
		public function get unselectable():uint { return _unselectable; }

		/**
		 * 0 = Authored as dynamic text 
		 * 1 = Authored as static text
		 */		
		public function get staticText():uint { return _staticText; }

	}
}