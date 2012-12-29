package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 2:19:28 PM
	 */
	public class ShapeRecord implements ICodec
	{
		protected var _shape:uint;
		protected var _type:uint;
		
		/**
		 * 构造函数
		 * create a [ShapeRecord] object
		 */
		public function ShapeRecord(shape:uint)
		{
			_shape = shape;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			decoder.position--;
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}

		/**
		 * If 0, the shape record is a non- edge record,
		 */		
		public function get type():uint { return _type; }

	}
}