package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.shape.Shape;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:12:58 PM
	 */
	public class DefineFontTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_FONT;
		
		protected var _offset:uint;
		protected var _offsetTable:Vector.<uint>;
		protected var _glyphs:Vector.<Shape>;
		
		protected var _fontInfo:DefineFontInfoTag;
		
		/**
		 * 构造函数
		 * create a [DefineFontTag] object
		 */
		public function DefineFontTag()
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
			
			_offset = decoder.readUI16();
			
			var length:uint, i:int;
			length = _offset / 2;
			
			_offsetTable = new Vector.<uint>(length, true);
			for (i = 0; i < length; i++)
			{
				_offsetTable[i] = decoder.readUI16();
			}
			
			_glyphs = new Vector.<Shape>(length, true);
			for (i = 0; i < length; i++)
			{
				_glyphs[i] = new Shape(TagType.DEFINE_SHAPE3);
				_glyphs[i].decode(decoder);
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
			encoder.writeUI16(_offset);
			
			var length:uint, i:int;
			length = _offset / 2;
			
			for (i = 0; i < length; i++)
			{
				encoder.writeUI16(_offsetTable[i]);
			}
			
			for (i = 0; i < length; i++)
			{
				_glyphs[i].encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineFontTag/>");
			result.@character = _character;
			
			var lenght:uint = _glyphs.length;
			for (var i:int = 0; i < lenght; i++)
			{
				result.appendChild(new XML(_glyphs[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Array of shapes
		 */		
		public function get glyphs():Vector.<Shape> { return _glyphs; }

		/**
		 * font info
		 */		
		public function get fontInfo():DefineFontInfoTag { return _fontInfo; }
		public function set fontInfo(value:DefineFontInfoTag):void
		{
			_fontInfo = value;
		}


	}
}