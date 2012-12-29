package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 1:35:22 PM
	 */
	public class FillStyleArray implements ICodec
	{
		private var _count:uint;
		private var _styles:Vector.<FillStyle>;
		private var _shape:uint;
		
		/**
		 * 构造函数
		 * create a [FillStyleArray] object
		 */
		public function FillStyleArray(shape:uint)
		{
			_shape = shape;
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
			
			_styles = new Vector.<FillStyle>(length, true);
			for (i = 0; i < length; i++)
			{
				_styles[i] = new FillStyle(_shape);
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
			var result:XML = new XML("<FillStyleArray/>");
			result.@length = _styles.length;
			
			var length:uint = _styles.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_styles[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Array of fill styles.
		 */		
		public function get styles():Vector.<FillStyle> { return _styles; }

	}
}