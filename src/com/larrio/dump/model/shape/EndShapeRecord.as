package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 12:41:41 PM
	 */
	public class EndShapeRecord extends ShapeRecord
	{
		private var _endOfShape:uint;
		
		/**
		 * 构造函数
		 * create a [EndShapeRecord] object
		 */
		public function EndShapeRecord(shape:uint)
		{
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_type = decoder.readUB(1);
			assertTrue(_type == 0);
			
			_endOfShape = decoder.readUB(5);
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_type, 1);
			encoder.writeUB(_endOfShape, 5);
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<EndShapeRecord/>");
			result.@type = _type;
			result.@endOfShape = _endOfShape;
			return result.toXMLString();	
		}

		/**
		 * End of shape flag. Always 0.
		 */		
		public function get endOfShape():uint { return _endOfShape; }

	}
}