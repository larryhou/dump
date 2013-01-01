package com.larrio.dump.model.text
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 1, 2013 1:50:51 PM
	 */
	public class GlyphEntry implements ICodec
	{
		private var _numgbits:uint;
		private var _numabits:uint;
		
		private var _index:uint;
		private var _advance:int;
		
		/**
		 * 构造函数
		 * create a [GlyphEntry] object
		 */
		public function GlyphEntry(numgbits:uint, numabits:uint)
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
			_index = decoder.readUB(_numgbits);
			_advance = decoder.readSB(_numabits);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_index, _numgbits);
			encoder.writeSB(_advance, _numabits);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<GlyphEntry/>");
			result.@index = _index;
			result.@advance = _advance;
			return result.toXMLString();	
		}

		/**
		 * Glyph index into current font.
		 */		
		public function get index():uint { return _index; }

		/**
		 * x advance value for glyph.
		 */		
		public function get advance():int { return _advance; }

	}
}