package com.larrio.dump.codec
{
	import com.larrio.math.sign;
	
	import flash.utils.ByteArray;
	
	/**
	 * SWF字节解码器
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:49:46 PM
	 */
	public class FileDecoder extends ByteArray
	{
		private var _bitpos:uint;
		private var _bitbuf:uint;
		
		/**
		 * 构造函数
		 * create a [FileDecoder] object
		 */
		public function FileDecoder()
		{
			_bitpos = 0;
			_bitbuf = 0;
		}	
		
		/**
		 * 字节对齐处理
		 */		
		public function byteAlign():void
		{
			_bitpos = 0; _bitbuf = 0;
		}
		
		/**
		 * 读取N位无符号整形
		 */		
		public function readUB(length:uint):uint
		{
			if (length == 0) return 0;
			
			var result:uint = 0;
			var left:int = length;
			
			if (_bitpos == 0)
			{
				_bitbuf = readUI8();
				_bitpos = 8;
			}
			
			var shift:int;
			while (true)
			{
				shift = left - _bitpos;
				if (shift > 0)
				{
					// 跨字节，取整个字节放到高位
					result |= _bitbuf << shift;
					left -= _bitpos;
					
					// 读取下一个字节
					_bitbuf = readUI8();
					_bitpos = 8;
				}
				else
				{
					// 取出left个高位放到result低位
					result |= _bitbuf >> -shift;
					 
					_bitpos -= left;		
					_bitbuf &= 0xFF >> (8 - _bitpos); // 取出shift个低位存储到bitbuf
					
					break;
				}
			}
			
			return result;
		}
		
		/**
		 * 读取8位单字节无符号整形
		 */		
		public function readUI8():uint
		{
			byteAlign();
			
			return readUnsignedByte();
		}
		
		/**
		 * 读取16位两字节无符号整形
		 */		
		public function readUI16():uint
		{
			byteAlign();
			
			return readUI8() | readUI8() << 8;
		}
		
		/**
		 * 读取24位三字节无符号整形
		 */		
		public function readUI24():uint
		{
			byteAlign();
			
			return readUI8() | readUI8() << 8 | readUI8() << 16;
		}
		
		/**
		 * 读取32位四字节无符号整形
		 */		
		public function readUI32():uint
		{
			byteAlign();
			
			return readUI8() | readUI8() << 8 | readUI8() << 16 | readUI8() << 24;
		}
		
		/**
		 * 读取30位被编码变长度无符号整形
		 */		
		public function readEU30():uint
		{
			return readEU32();
		}
		
		/**
		 * 读取32位被编码变长度无符号整形
		 */		
		public function readEU32():uint
		{
			byteAlign();
			
			var result:uint = readUI8();
			if (!(result & 0x00000080)) return result;
			
			result = (result & 0x0000007F) | readUI8() << 7;
			if (!(result & 0x00004000)) return result;
			
			result = (result & 0x00003FFF) | readUI8() << 14;
			if (!(result & 0x00200000)) return result;
			
			result = (result & 0x001FFFFF) | readUI8() << 21;
			if (!(result & 0x10000000)) return result;
			
			result = (result & 0x0FFFFFFF) | readUI8() << 28;
			return result;
		}
		
		/**
		 * 读取N位有符号整形
		 */		
		public function readSB(length:uint):int
		{
			return sign(readUB(length), length);
		}
		
		/**
		 * 读取8位单字节无符号整形
		 */		
		public function readS8():int
		{
			return sign(readUI8(), 8);
		}
		
		/**
		 * 读取16位两字节有符号整形
		 */		
		public function readS16():int
		{
			return sign(readUI16(), 16);
		}
		
		/**
		 * 读取24位三字节有符号整形
		 */		
		public function readS24():int
		{
			return sign(readUI24(), 24);
		}
		
		/**
		 * 读取32位四字节有符号整形
		 */		
		public function readS32():int
		{
			return sign(readUI32(), 32);
		}
		
		/**
		 * 读取30位被编码变长度无符号整形
		 */		
		public function readES30():uint
		{
			return sign(readEU30(), 30);
		}

		/**
		 * 读取32位被编码变长度有符号整形
		 */		
		public function readES32():uint
		{
			return sign(readEU32(), 32);
		}
		
		/**
		 * 读取字符串
		 */		
		public function readSTR():String
		{
			var bytes:ByteArray = new ByteArray();
			
			var byte:int;
			while ((byte = readUI8()) > 0) 
			{
				bytes.writeByte(byte);
			}
			
			bytes.position = 0;
			return bytes.readMultiByte(bytes.length, "utf-8");
		}		
	}
}