package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.MatrixRecord;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.model.text.TextRecord;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:35:47 PM
	 */
	public class DefineTextTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_TEXT;
		
		protected var _bounds:SWFRect;
		protected var _matrix:MatrixRecord;
		
		protected var _numgbits:uint;
		protected var _numabits:uint;
		
		protected var _records:Vector.<TextRecord>;
		
		/**
		 * 构造函数
		 * create a [DefineTextTag] object
		 */
		public function DefineTextTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_dict[_character] = this;
			
			_bounds = new SWFRect();
			_bounds.decode(decoder);
			
			_matrix = new MatrixRecord();
			_matrix.decode(decoder);
			
			_numgbits = decoder.readUI8();
			_numabits = decoder.readUI8();
			
			_records = new Vector.<TextRecord>();
			
			var record:TextRecord;
			while(decoder.readUI8())
			{
				decoder.position--;
				record = new TextRecord(_numgbits, _numabits, _type);
				record.decode(decoder);
				
				_records.push(record);
			}
			
			assertTrue(decoder.bytesAvailable == 0);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			_bounds.encode(encoder);
			_matrix.encode(encoder);
			
			encoder.writeUI8(_numgbits);
			encoder.writeUI8(_numabits);
			
			var length:uint = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				_records[i].encode(encoder);
			}
			
			// end flag
			encoder.writeUI8(0);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var localName:String = getQualifiedClassName(this).split("::")[1];
			var result:XML = new XML("<" + localName + "/>");
			result.@character = _character;
			
			result.appendChild(new XML(_bounds.toString()));
			result.appendChild(new XML(_matrix.toString()));
			
			var length:int = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_records[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Bounds of the text.
		 */		
		public function get bounds():SWFRect { return _bounds; }

		/**
		 * Transformation matrix for the text.
		 */		
		public function get matrix():MatrixRecord { return _matrix; }

		/**
		 * Text records.
		 */		
		public function get records():Vector.<TextRecord> { return _records; }

	}
}