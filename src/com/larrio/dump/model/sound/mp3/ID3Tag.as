package com.larrio.dump.model.sound.mp3
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.ByteArray;
	
	/**
	 * ID3 v2.4.0
	 * @author larryhou
	 * @createTime Jul 4, 2013 2:38:05 PM
	 */
	public class ID3Tag implements ICodec
	{
		private var _identifier:String;
		private var _version:uint;
		private var _flags:uint;
		
		private var _data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [ID3Tag] object
		 */
		public function ID3Tag()
		{
			
		}
		
		/**
		 * 判定当前位置是否为ID3Tag
		 * @param source	字节数据
		 */		
		public static function verify(source:ByteArray):Boolean
		{
			if (source.bytesAvailable < 10) return false;
			var str:String = source.readMultiByte(3, "utf-8");
			source.position -= 3;
			
			return str == "ID3";
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_identifier = decoder.readMultiByte(3, "utf-8");
			_version = decoder.readUI16();
			_flags = decoder.readUI8();
			
			var size:uint = 0;
			size |= (decoder.readUI8() & 0x7F) << 21;
			size |= (decoder.readUI8() & 0x7F) << 14;
			size |= (decoder.readUI8() & 0x7F) << 7;
			size |= (decoder.readUI8() & 0x7F) << 0;
			
			_data = new ByteArray();
			if (decoder.bytesAvailable)
			{
				decoder.readBytes(_data, 0, size);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeMultiByte(_identifier, "utf-8");
			encoder.writeUI16(_version);
			encoder.writeUI8(_flags);
			
			var size:uint = _data.length;
			encoder.writeUI8((size >>> 21) & 0x7F);
			encoder.writeUI8((size >>> 14) & 0x7F);
			encoder.writeUI8((size >>> 7) & 0x7F);
			encoder.writeUI8((size >>> 0) & 0x7F);
			
			if (_data.length)
			{
				encoder.writeBytes(_data);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "<ID3Tag/>";	
		}

		/**
		 * ID3Tag内容
		 */		
		public function get data():ByteArray { return _data; }

		/**
		 * 标记位
		 */		
		public function get flags():uint { return _flags; }

		/**
		 * 2字节版本号
		 */		
		public function get version():uint { return _version; }

		/**
		 * ID3标识符
		 */		
		public function get identifier():String { return _identifier; }

	}
}