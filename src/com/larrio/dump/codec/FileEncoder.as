package com.larrio.dump.codec
{
	import com.larrio.math.unsign;
	
	import flash.utils.ByteArray;
	import com.larrio.dump.utils.assertInt;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * SWF字节编码器
	 * @author larryhou
	 * @createTime Dec 15, 2012 4:22:02 PM
	 */
	dynamic public class FileEncoder extends ByteArray
	{
		private var _byte:uint;
		private var _bitpos:uint;
		
		/**
		 * 构造函数
		 * create a [FileEncoder] object
		 */
		public function FileEncoder()
		{
			_byte = 0;
			_bitpos = 8;
		}
		
		/**
		 * 写入N位无符号整形
		 * @param value		写入数值
		 * @param size		二进制存储占用比特位数量
		 */		
		public function writeUB(value:uint, size:uint):void
		{
			while (size > 0)
			{
				if (size > _bitpos)
				{
					//if more bits left to write than shift out what will fit
					_byte |= value << (32 - size) >>> (32 - _bitpos);
					size -= _bitpos;
					
					// shift all the way left, then right to right
					// justify the data to be or'ed in
					writeByte(_byte);
					
					_byte = 0;
					_bitpos = 8;
				}
				else
				{
					_byte |= value << (32 - size) >>> (32 - _bitpos);
					_bitpos -= size;
					
					size = 0;
					
					if (_bitpos == 0)
					{
						//if current byte is filled
						writeByte(_byte);
						
						_byte = 0;
						_bitpos = 8;
					}
				}
			}
		}
		
		/**
		 * 写入8位单字节无符号整形
		 */		
		public function writeUI8(value:uint):void
		{
			assertTrue(_bitpos == 8);
			assertTrue(value <= 0xFF);
			
			writeByte(value);
		}
		
		/**
		 * 写入16位两字节无符号整形
		 */		
		public function writeUI16(value:uint):void
		{
			assertTrue(_bitpos == 8);
			assertTrue(value <= 0xFFFF);
			
			writeByte(value);
			writeByte(value >>> 8);
		}
		
		/**
		 * 写入24位三字节无符号整形
		 */		
		public function writeUI24(value:uint):void
		{
			assertTrue(_bitpos == 8);
			assertTrue(value <= 0xFFFFFF);
			
			writeByte(value);
			writeByte(value >>> 8);
			writeByte(value >>> 16);
		}
		
		/**
		 * 写入32位四字节无符号整形
		 */		
		public function writeUI32(value:uint):void
		{
			assertTrue(_bitpos == 8);
			assertTrue(value <= 0xFFFFFFFF);
			
			writeByte(value);
			writeByte(value >>> 8);
			writeByte(value >>> 16);
			writeByte(value >>> 24);
		}
		
		/**
		 * 写入30位被编码变长度无符号整形
		 */		
		public function writeEU30(value:uint):void
		{
			assertTrue(_bitpos == 8);
			assertTrue(value <= (0xFFFFFFFF >>> 2));
			
			writeEU32(value);
		}
		
		/**
		 * 写入32位被编码变长度无符号整形
		 */		
		public function writeEU32(value:uint):void
		{
			assertTrue(_bitpos == 8);
			assertTrue(value <= 0xFFFFFFFF);
			
			var byte:uint;
			while (value > 0)
			{
				byte = value & 0x7F;			
				if ((value >>>= 7) > 0) byte |= (1 << 7);
				
				writeByte(byte);
			}
		}
		
		/**
		 * 写入N位有符号整形
		 */		
		public function writeSB(value:int, size:uint):void
		{
			assertInt(value, size);
			writeUB(unsign(value, size), size);
		}
		
		/**
		 * 写入8位单字节无符号整形
		 */		
		public function writeS8(value:int):void
		{
			assertInt(value, 8);			
			writeUI8(value);
		}
		
		/**
		 * 写入16位两字节有符号整形
		 */		
		public function writeS16(value:int):void
		{
			assertInt(value, 16);			
			writeUI16(value);
		}
		
		/**
		 * 写入24位三字节有符号整形
		 */		
		public function writeS24(value:int):void
		{
			assertInt(value, 24);
			writeUI24(value);
		}
		
		/**
		 * 写入32位四字节有符号整形
		 */		
		public function writeS32(value:int):void
		{
			assertInt(value, 32);			
			writeUI32(value);
		}
		
		/**
		 * 写入30位被编码变长度无符号整形
		 */		
		public function writeES30(value:int):void
		{
			assertInt(value, 30);			
			writeEU30(value);
		}
		
		/**
		 * 写入32位被编码变长度有符号整形
		 */		
		public function writeES32(value:int):void
		{
			assertInt(value, 32);			
			writeEU32(value);
		}
		
		/**
		 * 对超类进行引用
		 */		
		public function get bytes():ByteArray { return super; }
	}
}