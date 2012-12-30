package com.larrio.dump.model.morph
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 1:58:55 PM
	 */
	public class MorphFillStyleArray implements ICodec
	{
		private var _count:int;
		private var _styles:Vector.<MorphFillStyle>;
		
		/**
		 * 构造函数
		 * create a [MorphFillStyleArray] object
		 */
		public function MorphFillStyleArray()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var length:uint, i:int;
			length = _count = decoder.readUI8();
			if (_count == 0xFF)
			{
				length = decoder.readUI16();
			}
			
			_styles = new Vector.<MorphFillStyle>(length, true);
			for (i = 0; i < length; i++)
			{
				_styles[i] = new MorphFillStyle();
				_styles[i].decode(decoder);
			}
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:uint, i:int;
			length = _styles.length;
			
			encoder.writeUI8(_count);
			if (_count == 0xFF)
			{
				encoder.writeUI16(length);
			}
			
			for (i = 0; i < length; i++)
			{
				_styles[i].encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<MorphFillStyleArray/>");
			result.@length = _styles.length;
			
			var item:XML;
			var length:uint = _styles.length;
			for (var i:int = 0; i < length; i++)
			{
				item = new XML(_styles[i].toString());
				item.@index = i;
				
				result.appendChild(item);
			}
			
			return result.toXMLString();	
		}

		/**
		 * Array of fill styles.
		 */		
		public function get styles():Vector.<MorphFillStyle> { return _styles; }

	}
}