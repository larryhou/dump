package com.larrio.dump.model.sound.mp3
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 9:41:41 AM
	 */
	public class MP3Frame implements ICodec
	{
		private var _sync:uint;
		private var _version:uint;
		private var _layer:uint;
		
		private var _protection:uint;
		
		private var _bitrate:uint;
		private var _samplingRate:uint;
		private var _padding:uint;
		private var _reserved:uint;
		
		private var _channelMode:uint;
		private var _extension:uint;
		
		private var _copyright:uint;
		private var _original:uint;
		
		private var _emphasis:uint;
		private var _data:ByteArray;
		
		private var _duration:Number;
		private var _sampleCount:uint;
		
		/**
		 * 构造函数
		 * create a [MP3Frame] object
		 */
		public function MP3Frame()
		{
			
		}
		
		/**
		 * 检测当前字节位置是否为MP3Frame对象
		 * @param source	MP3字节数组
		 */		
		public static function verify(source:ByteArray):Boolean
		{
			if (source.bytesAvailable < 4) return false;
			
			var flags:uint = source.readUnsignedInt();
			source.position -= 4;
			
			var decoder:FileDecoder = new FileDecoder();
			decoder.writeUnsignedInt(flags);
			decoder.position = 0;
			
			var result:Boolean = true;
			result &&= decoder.readUB(11) == 0x7FF;	// check sync
			result &&= decoder.readUB(2) != 1;		// check version
			result &&= decoder.readUB(2) != 0;		// check layer
			
			decoder.readUB(1);
			
			var value:uint = decoder.readUB(4);
			result &&= value != 15 && value != 0;	// check bitRate
			result &&= decoder.readUB(2) != 3;		// check samplingRate
			
			return result;
		}
				
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_sync = decoder.readUB(11);
			
			assertTrue((~_sync & 0x7FF) == 0);
			
			_version = decoder.readUB(2);
			_layer = decoder.readUB(2);
			_protection = decoder.readUB(1);
			_bitrate = decoder.readUB(4);
			_samplingRate = decoder.readUB(2);
			_padding = decoder.readUB(1);
			_reserved = decoder.readUB(1);
			
			_channelMode = decoder.readUB(2);
			_extension = decoder.readUB(2);
			
			_copyright = decoder.readUB(1);
			_original = decoder.readUB(1);
			_emphasis = decoder.readUB(2);
			
			decoder.byteAlign();
			
			_data = new ByteArray();
			var size:uint = caculateSampleSize();
			
			if (decoder.bytesAvailable)
			{
				decoder.readBytes(_data, 0, Math.min(size, decoder.bytesAvailable));
			}
			
			var rbitRate:uint = BitRate.getRate(_bitrate, _version, _layer);
			
			_sampleCount = FrameSamples.getFrameCount(_version, _layer);
			_duration = _data.length / rbitRate * 8;
		}	
				
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_sync, 11);
			encoder.writeUB(_version, 2);
			encoder.writeUB(_layer, 2);
			encoder.writeUB(_protection, 1);
			encoder.writeUB(_bitrate, 4);
			encoder.writeUB(_samplingRate, 2);
			encoder.writeUB(_padding, 1);
			encoder.writeUB(_reserved, 1);
			
			encoder.writeUB(_channelMode, 2);
			encoder.writeUB(_extension, 2);
			encoder.writeUB(_copyright, 1);
			encoder.writeUB(_original, 1);
			encoder.writeUB(_emphasis, 2);
			encoder.flush();
			
			if (_data.length)
			{
				encoder.writeBytes(_data);
			}
		}
		
		/**
		 * 计算样本数据字节大小
		 */		
		private function caculateSampleSize():uint
		{
			var rbitRate:uint = BitRate.getRate(_bitrate, _version, _layer);
			var rsamplingRate:uint = SamplingRate.getRate(_samplingRate, _version);
			
			return ((_version == MpegVersion.MPEG1? 144 : 72) * rbitRate) / rsamplingRate + _padding - 4;
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<MP3Frame/>");
			result.@version = MpegVersion.getVersion(_version);
			result.@layer = MpegLayer.getLayer(_layer);
			result.@bitRate = BitRate.getRate(_bitrate, _version, _layer);
			result.@samplingRate = SamplingRate.getRate(_samplingRate, _version);
			result.@channelMode = getChannelMode();
			result.@orignal = _original;
			result.@copyright = _copyright;
			result.@sampleSize = _data? _data.length : 0;
			result.@length = (_data? _data.length : 0) + 4;
			return result.toXMLString();
		}
		
		/**
		 * 获取升到字符串表示
		 */		
		private function getChannelMode():String
		{
			switch(_channelMode)
			{
				case 0:case 1:return "Stereo";
				case 2:return "Dual";
				case 3:return "Mono";
			}
			
			return "unknown";
		}

		/**
		 * encoded audio samples
		 */		
		public function get data():ByteArray { return _data; }
		public function set data(value:ByteArray):void
		{
			_data = value;
		}

		/**
		 * 0: none
		 * 1: 50 / 15 ms
		 * 2: reserved
		 * 3: CCIT J.17
		 */		
		public function get emphasis():uint { return _emphasis; }
		public function set emphasis(value:uint):void
		{
			_emphasis = value;
		}

		/**
		 * 0: copy of original media
		 * 1: original media
		 */		
		public function get original():uint { return _original; }
		public function set original(value:uint):void
		{
			_original = value;
		}

		/**
		 * 0: audio is not copyrighted
		 * 1: audio is copyrighted
		 */		
		public function get copyright():uint { return _copyright; }
		public function set copyright(value:uint):void
		{
			_copyright = value;
		}

		/**
		 * 0: Stereo
		 * 1: Joint stereo
		 * 2: Dual Channel
		 * 3: Mono 
		 */		
		public function get channelMode():uint { return _channelMode; }
		public function set channelMode(value:uint):void
		{
			_channelMode = value;
		}

		/**
		 * 0: frame is not padded
		 * 1: frame is padded with one extra slot
		 */		
		public function get padding():uint { return _padding; }
		public function set padding(value:uint):void
		{
			_padding = value;
		}

		/**
		 * Sampling rate in Hz.
		 * -------------------------------
		 * Value   MPEG1  MPEG2.x  MPEG2.5
		 * -------------------------------
		 * 0       44100  22050    11025
		 * 1       48000  24000    12000
		 * 2       32000  16000    8000
		 * -------------------------------
		 */		
		public function get samplingRate():uint { return _samplingRate; }
		public function set samplingRate(value:uint):void
		{
			_samplingRate = value;
		}

		/**
		 * bitrates are in thounsands of bits per second(×1000).
		 * 0    free   free
		 * 1    32     8
		 * 2    40     16
		 * 3    48     24
		 * 4    56     32
		 * 5    64     40
		 * 6    80     48
		 * 7    96     56
		 * 8    112    64
		 * 9    128    80
		 * 10   160    96
		 * 11   192    112
		 * 12   224    128
		 * 13   256    144
		 * 14   320    160
		 * 15   bad    bad
		 */		
		public function get bitrate():uint { return _bitrate; }
		public function set bitrate(value:uint):void
		{
			_bitrate = value;
		}

		/**
		 * 0: protected by CRC, 16-bit CRC follows the header
		 * 1: not protected
		 * 
		 */		
		public function get protection():uint { return _protection; }
		public function set protection(value:uint):void
		{
			_protection = value;
		}

		/**
		 * Layer is always equal to 1 for MP3 headers in SWF files.
		 * The 3 in MP3 refers to the Layer, not the MpegVersion.
		 * 0: reserved
		 * 1: Layer 3
		 * 2: Layer 2
		 * 3: Layer 1
		 */		
		public function get layer():uint { return _layer; }
		public function set layer(value:uint):void
		{
			_layer = value;
		}

		/**
		 * MPEG2.5 is an extension to MPEG2 that handles very low bitrates,
		 * allowing the use of lower sampling frequencies.
		 * 0: MPEG2.5
		 * 1: reserved
		 * 2: MPEG 2
		 * 3: MPEG 1
		 */		
		public function get version():uint { return _version; }
		public function set version(value:uint):void
		{
			_version = value;
		}

		/**
		 * Frame sync. All bits must be set.
		 */		
		public function get sync():uint { return _sync; }
		public function set sync(value:uint):void
		{
			_sync = value;
		}

		/**
		 * 单帧播放时长
		 */		
		public function get duration():Number { return _duration; }

		/**
		 * 单帧包含样本数
		 */		
		public function get sampleCount():uint { return _sampleCount; }
	}
}