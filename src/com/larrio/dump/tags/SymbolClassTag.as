package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 链接名TAG
	 * @author larryhou
	 * @createTime Dec 16, 2012 2:29:28 PM
	 */
	public class SymbolClassTag extends SWFTag
	{
		public static const TYPE:uint = TagType.SYMBOL_CLASS;
		
		private var _ids:Vector.<uint>;
		private var _symbols:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [SymbolClassTag] object
		 */
		public function SymbolClassTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == SymbolClassTag.TYPE);
			
			decoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			var length:uint, i:int;
			length = decoder.readUI16();
			
			_ids = new Vector.<uint>(length, true);
			_symbols = new Vector.<String>(length, true);
			
			for (i = 0; i < length; i++)
			{
				_ids[i] = decoder.readUI16();
				_symbols[i] = decoder.readSTR();
			}
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			var length:uint, i:int;
			
			length = _ids.length;
			encoder.writeUI16(length);
			
			for (i = 0; i < length; i++)
			{
				encoder.writeUI16(_ids[i]);
				encoder.writeSTR(_symbols[i]);
			}
			
		}
		
		/**
		 * 链接名唯一id
		 */		
		public function get ids():Vector.<uint> { return _ids; }

		/**
		 * 链接名完全限定名
		 */		
		public function get symbols():Vector.<String> { return _symbols; }

	}
}