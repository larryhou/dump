package com.larrio.dump.model.sound.mp3
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.sound.mp3.id3.ID3Tag;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * MP3文件编码器
	 * @author larryhou
	 * @createTime Jul 4, 2013 9:41:53 AM
	 */
	public class MP3File
	{
		private var _seekSamples:int;
		
		private var _frames:Vector.<MP3Frame>;
		private var _tags:Vector.<ID3Tag>;
		
		private var _sampleCount:uint;
		private var _samplingRate:uint;
		private var _skipBytes:uint;
		
		private var _length:uint;
		private var _duration:Number;
		
		private var _standalone:Boolean;
		private var _unknowns:Vector.<UnknownByte>;
		
		/**
		 * 构造函数
		 * create a [MP3File] object
		 * @param standalone	是否为独立MP3文件，相对于SoundTag嵌入文件
		 */		
		public function MP3File(standalone:Boolean = false)
		{
			_standalone = standalone;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(bytes:ByteArray):void
		{
			_skipBytes = 0;
			
			_duration = 0;
			_sampleCount = 0;
			
			var decoder:FileDecoder = new FileDecoder();
			decoder.writeBytes(bytes);
			decoder.position = 0;
			
			_length = decoder.length;
			if (!_standalone)
			{
				_seekSamples = decoder.readS16();
			}
			
			_tags = new Vector.<ID3Tag>;
			_frames = new Vector.<MP3Frame>();
			_unknowns = new Vector.<UnknownByte>;
			
			var rate:uint;
			var map:Dictionary = new Dictionary();
			
			var position:uint;
			var frame:MP3Frame, id3:ID3Tag;
			while (decoder.bytesAvailable)
			{
				position = decoder.position;
				while (ID3Tag.verify(decoder))
				{
					id3 = new ID3Tag();
					id3.decode(decoder);
					_tags.push(id3);
				}
				
				while (MP3Frame.verify(decoder))
				{
					frame = new MP3Frame();
					frame.decode(decoder);
					
					rate = SamplingRate.getRate(frame.samplingRate, frame.version);
					if (!map[rate]) map[rate] = 0;
					map[rate]++;
					
					_duration += frame.duration;
					_sampleCount += frame.sampleCount;
					
					_frames.push(frame);
				}
				
				if (position == decoder.position) 
				{
					_skipBytes++;
					_unknowns.push(new UnknownByte(decoder.position, decoder.readByte())); 
				}
			}
			
			_samplingRate = 0;
			for (var r:* in map)
			{				
				if (uint(map[_samplingRate]) < uint(map[r])) _samplingRate = r;
			}
			
			assertTrue(decoder.bytesAvailable == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode():ByteArray
		{
			var encoder:FileEncoder = new FileEncoder();
			
			if (!_standalone)
			{
				encoder.writeS16(_seekSamples);
			}
			
			for (var i:int = 0, length:uint = _frames.length; i < length; i++)
			{
				_frames[i].encode(encoder);
			}
			
			return encoder;
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<MP3File/>");
			result.@frameCount = _frames.length;
			result.@sampleCount = _sampleCount;
			result.@seekSamples = _seekSamples;
			result.@duration = _duration.toFixed(1) + "s";
			result.@id3Count = _tags.length;
			result.@skipBytes = _skipBytes;
			result.@length = _length;
			
			var i:uint, len:uint;
			for (i = 0, len = _frames.length; i < len; i++)
			{
				result.appendChild(new XML(_frames[i].toString()));
			}
			
			var byte:UnknownByte, item:XML;
			var bytes:XML = new XML("<Unknowns/>");
			for (i = 0, len = _unknowns.length; i < len; i++)
			{
				byte = _unknowns[i];
				item = new XML("<byte/>");
				item.@offset = byte.offset;
				item.@value = byte.byte.toString(16).toUpperCase();
				item.@char = String.fromCharCode(byte.byte);
				bytes.appendChild(item);
			}
			
			result.appendChild(bytes);
			
			return result.toXMLString();
		}

		/**
		 * MP3帧信息
		 */		
		public function get frames():Vector.<MP3Frame> { return _frames; }
		public function set frames(value:Vector.<MP3Frame>):void
		{
			_frames = value;
		}

		/**
		 * Number of samples to skip
		 */		
		public function get seekSamples():int { return _seekSamples; }
		public function set seekSamples(value:int):void
		{
			_seekSamples = value;
		}

		/**
		 * 采样数据总数
		 */		
		public function get sampleCount():uint { return _sampleCount; }

		/**
		 * 为解析的未知字节信息列表
		 */		
		public function get unknowns():Vector.<UnknownByte> { return _unknowns; }

		/**
		 * 采样码率
		 */		
		public function get samplingRate():uint { return _samplingRate; }
	}
}