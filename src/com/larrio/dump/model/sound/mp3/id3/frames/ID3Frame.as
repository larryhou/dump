package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 12:36:36 AM
	 */
	public class ID3Frame implements ICodec
	{
		private var _identifier:String;
		private var _flags:uint;
		
		private var _data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [ID3Frame] object
		 */
		public function ID3Frame()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var _length:uint;
			
			_identifier = decoder.readUTFBytes(4);
			
			_length = decoder.readSynchsafe();
			_flags = decoder.readUI16();
			
			_data = new ByteArray();
			if (_length)
			{
				decoder.readBytes(_data, 0, _length);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUTFBytes(_identifier);
			encoder.writeSynchsafe(_data.length);
			encoder.writeUI16(_flags);
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
			return "";	
		}

		/**
		 * 帧标记
		 */		
		public function get identifier():String { return _identifier; }

		/**
		 * 标记位
		 */		
		public function get flags():uint { return _flags; }

		/**
		 * 帧数据
		 */		
		public function get data():ByteArray { return _data; }
	}
}