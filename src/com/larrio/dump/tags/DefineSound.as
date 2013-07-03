package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 3, 2013 5:25:22 PM
	 */
	public class DefineSound extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_SOUND;
		
		private var _format:uint;
		
		private var _sampleRate:uint;
		
		private var _sampleSize:uint;
		
		private var _soundType:uint;
		
		private var _sampleCount:uint;
		
		private var _data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [DefineSound] object
		 */
		public function DefineSound()
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
			
			_format = decoder.readUB(4);
			_sampleRate = decoder.readUB(2);
			_sampleSize = decoder.readUB(1);
			_soundType = decoder.readUB(1);
			
			_sampleCount = decoder.readUI32();
			_data = new ByteArray();
			
			decoder.readBytes(_data);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeUB(_format, 4);
			encoder.writeUB(_sampleRate, 2);
			encoder.writeUB(_sampleSize, 1);
			encoder.writeUB(_soundType, 1);
			
			encoder.writeUI32(_sampleCount);
			encoder.writeBytes(_data);
		}
					
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineSound/>");
			result.@format = _format;
			result.@sampleRate = _sampleRate;
			result.@smapleSize = _sampleSize;
			result.@soundType = _soundType;
			result.@length = _data.length;
			return result.toXMLString();	
		}

		/**
		 * 音频编码格式
		 */		
		public function get format():uint { return _format; }
		public function set format(value:uint):void
		{
			_format = value;
		}

		/**
		 * 采样码率
		 * @see com.larrio.dump.model.sound.SoundRateType
		 */		
		public function get sampleRate():uint { return _sampleRate; }
		public function set sampleRate(value:uint):void
		{
			_sampleRate = value;
		}

		/**
		 * 0：8位
		 * 1：16位
		 * 压缩音频始终16位
		 */		
		public function get sampleSize():uint { return _sampleSize; }
		public function set sampleSize(value:uint):void
		{
			_sampleSize = value;
		}

		/**
		 * 单声道、立体声
		 */		
		public function get soundType():uint { return _soundType; }
		public function set soundType(value:uint):void
		{
			_soundType = value;
		}

		/**
		 * 采样数量
		 */		
		public function get sampleCount():uint { return _sampleCount; }
		public function set sampleCount(value:uint):void
		{
			_sampleCount = value;
		}

		/**
		 * 音频文件
		 */		
		public function get data():ByteArray { return _data; }
		public function set data(value:ByteArray):void
		{
			_data = value;
		}
	}
}