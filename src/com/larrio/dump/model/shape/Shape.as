package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 5:01:21 PM
	 */
	public class Shape implements ICodec
	{
		protected var _shape:uint;
		protected var _numFillBits:uint;
		protected var _numLineBits:uint;
		protected var _records:Vector.<ShapeRecord>;
		
		/**
		 * 构造函数
		 * create a [Shape] object
		 */
		public function Shape(shape:uint)
		{
			_shape = shape;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_numFillBits = decoder.readUB(4);
			_numLineBits = decoder.readUB(4);
			
			_records = new Vector.<ShapeRecord>();
			
			var record:ShapeRecord, flag:Boolean = false;
			
			while (!flag)
			{
				if (decoder.readUB(1))
				{
					if (decoder.readUB(1))
					{
						// straight
						record = new StraightEdgeRecord(_shape);
					}
					else
					{
						// curve
						record = new CurvedEdgeRecord(_shape);
					}
				}
				else
				{
					if (decoder.readUB(5))
					{
						// style change
						record = new StyleChangeRecord(_shape, _numFillBits, _numLineBits);
					}
					else
					{
						// end
						record = new EndShapeRecord(_shape);
						flag = true;
					}
				}
				
				record.decode(decoder);
				_records.push(record);
			}			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_numFillBits, 4);
			encoder.writeUB(_numLineBits, 4);
			
			var length:int = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				_records[i].encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<Shape/>");
			
			var length:int = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_records[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Shape records
		 */		
		public function get records():Vector.<ShapeRecord> { return _records; }

	}
}