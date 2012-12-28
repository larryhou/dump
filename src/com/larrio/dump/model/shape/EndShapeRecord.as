package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 12:41:41 PM
	 */
	public class EndShapeRecord implements ICodec
	{
		private var _type:uint;
		private var _endOfShape:uint;
		
		/**
		 * 构造函数
		 * create a [EndShapeRecord] object
		 */
		public function EndShapeRecord()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_type = decoder.readUB(1);
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
		public function toString():String
		{
			return "";	
		}

		/**
		 * Non-edge record flag. Always 0.
		 */		
		public function get type():uint { return _type; }

		/**
		 * End of shape flag. Always 0.
		 */		
		public function get endOfShape():uint { return _endOfShape; }

	}
}