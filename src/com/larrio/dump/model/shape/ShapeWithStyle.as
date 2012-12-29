package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 29, 2012 12:20:03 PM
	 */
	public class ShapeWithStyle extends Shape
	{
		private var _fillStyles:FillStyleArray;
		private var _lineStyles:LineStyleArray;
		
		/**
		 * 构造函数
		 * create a [ShapeWithStyle] object
		 */
		public function ShapeWithStyle(shape:uint)
		{
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			decoder.byteAlign();
			
			_fillStyles = new FillStyleArray(_shape);
			_fillStyles.decode(decoder);
			
			_lineStyles = new LineStyleArray(_shape);
			_lineStyles.decode(decoder);
			
			super.decode(decoder);
			
			assertTrue(decoder.bytesAvailable == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.flush();
			
			_fillStyles.encode(encoder);
			_lineStyles.encode(encoder);
			
			super.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<ShapeWithStyle/>");
			result.appendChild(new XML(_fillStyles.toString()));
			result.appendChild(new XML(_lineStyles.toString()));
			
			var length:int = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_records[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Array of fill styles.
		 */		
		public function get fillStyles():FillStyleArray { return _fillStyles; }

		/**
		 * Array of line styles.
		 */		
		public function get lineStyles():LineStyleArray { return _lineStyles; }

	}
}