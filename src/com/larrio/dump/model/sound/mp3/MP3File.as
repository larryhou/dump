package com.larrio.dump.model.sound.mp3
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * MP3文件编码器
	 * @author larryhou
	 * @createTime Jul 4, 2013 9:41:53 AM
	 */
	public class MP3File implements ICodec
	{
		private var _seekSamples:int;
		
		private var _frames:Vector.<MP3Frame>;
		private var _tags:Vector.<ID3Tag>;
		
		private var _sampleCount:uint;
		
		/**
		 * 构造函数
		 * create a [MP3File] object
		 */
		public function MP3File()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_sampleCount = 0;
			_seekSamples = decoder.readS16();
			
			_tags = new Vector.<ID3Tag>;
			_frames = new Vector.<MP3Frame>();
			
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
					
					_sampleCount += frame.data.length / 2;	// MP3的样本大小为2字节
					_frames.push(frame);
				}
				
				if (position == decoder.position) decoder.readByte();
			}
			
			assertTrue(decoder.bytesAvailable == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeS16(_seekSamples);
			for (var i:int = 0, length:uint = _frames.length; i < length; i++)
			{
				_frames[i].encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "<MP3File/>";	
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
	}
}