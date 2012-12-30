package com.larrio.dump.model.morph
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 1:30:45 PM
	 */
	public class MorphGradident implements ICodec
	{
		private var _records:Vector.<MorphGradientRecord>;
		
		/**
		 * 构造函数
		 * create a [MorphGradident] object
		 */
		public function MorphGradident()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var length:int = decoder.readUI8();
			assertTrue(length >= 1 && length <= 8);
			
			_records = new Vector.<MorphGradientRecord>(length, true);
			for (var i:int = 0; i < length; i++)
			{
				_records[i] = new MorphGradientRecord();
				_records[i].decode(decoder);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:int = _records.length;
			encoder.writeUI8(length);
			
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
			var result:XML = new XML("<MorphGradient/>");
			
			var length:int = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_records[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Gradient records
		 */		
		public function get records():Vector.<MorphGradientRecord> { return _records; }

	}
}