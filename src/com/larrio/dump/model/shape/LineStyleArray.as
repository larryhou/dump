package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.tags.TagType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 2:30:19 PM
	 */
	public class LineStyleArray implements ICodec
	{
		private var _shape:uint;
		private var _count:uint;
		private var _styles:Vector.<LineStyle>;
		
		/**
		 * 构造函数
		 * create a [LineStyleArray] object
		 */
		public function LineStyleArray(shape:uint)
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
			
			_styles = new Vector.<LineStyle>(length, true);
			for (i = 0; i < length; i++)
			{
				if (_shape == TagType.DEFINE_SHAPE4)
				{
					_styles[i] = new LineStyle2(_shape);
				}
				else
				{
					_styles[i] = new LineStyle(_shape);
				}
				
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
			var result:XML = new XML("<LineStyleArray/>");
			result.@length = _styles.length;
			
			var length:uint = _styles.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_styles[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Array of line styles.
		 */		
		public function get styles():Vector.<LineStyle> { return _styles; }

	}
}