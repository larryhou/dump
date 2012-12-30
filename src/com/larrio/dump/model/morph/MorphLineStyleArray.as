package com.larrio.dump.model.morph
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.tags.TagType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 2:41:31 PM
	 */
	public class MorphLineStyleArray implements ICodec
	{
		private var _shape:uint;
		private var _count:uint;
		private var _styles:Vector.<MorphLineStyle>;
		
		/**
		 * 构造函数
		 * create a [MorphLineStyleArray] object
		 */
		public function MorphLineStyleArray(shape:uint)
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
			
			_styles = new Vector.<MorphLineStyle>(length, true);
			for (i = 0; i < length; i++)
			{
				if (_shape == TagType.DEFINE_MORPH_SHAPE)
				{
					_styles[i] = new MorphLineStyle();
				}
				else
				{
					_styles[i] = new MorphLineStyle2();
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
			var result:XML = new XML("<MorphLineStyleArray/>");
			
			var length:uint = _styles.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_styles[i].toString()));
			}
			
			return result.toXMLString();	
		}
	}
}