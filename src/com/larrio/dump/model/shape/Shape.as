package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 5:01:21 PM
	 */
	public class Shape implements ICodec
	{
		protected var _shape:uint;
		
		protected var _numfbits:uint;
		protected var _numlbits:uint;
		
		protected var _records:Vector.<ShapeRecord>;
		
		private var _size:uint;
		
		/**
		 * 构造函数
		 * create a [Shape] object
		 */
		public function Shape(shape:uint, size:uint = 0)
		{
			_shape = shape;	_size = size;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			decoder.byteAlign();
			
			var offset:uint = decoder.position;
			
			_numfbits = decoder.readUB(4);
			_numlbits = decoder.readUB(4);
			
			_records = new Vector.<ShapeRecord>();
			
			var numfbits:uint = _numfbits;
			var numlbits:uint = _numlbits;
			
			var record:ShapeRecord, flag:uint;
			
			while (true)
			{
				if (decoder.readUB(1))
				{
					if (decoder.readUB(1))
					{
						// line
						record = new StraightEdgeShapeRecord(_shape);
					}
					else
					{
						// curve
						record = new CurvedEdgeShapeRecord(_shape);
					}
				}
				else
				{
					flag = decoder.readUB(5);
					if (flag)
					{
						// style change
						record = new StyleChangeShapeRecord(_shape, numfbits, numlbits, flag);
					}
					else
					{
						// end
						record = new EndShapeRecord()
					}
				}
				
				record.decode(decoder);
				if (record is StyleChangeShapeRecord)
				{
					numfbits = (record as StyleChangeShapeRecord).numfbits;
					numlbits = (record as StyleChangeShapeRecord).numlbits;
				}
				
				_records.push(record);
				if (record is EndShapeRecord) break;
			}	
			
			if (_size)
			{
//				offset = decoder.position - offset;
				decoder.position = offset + _size;
//				assertTrue(offset == _size);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.flush();
			
			encoder.writeUB(_numfbits, 4);
			encoder.writeUB(_numlbits, 4);
			
			var length:int = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				_records[i].encode(encoder);
			}
			
			// end shape
			encoder.writeUB(0, 1);
			encoder.writeUB(0, 5);
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