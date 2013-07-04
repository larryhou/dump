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
			_seekSamples = decoder.readS16();
			_frames = new Vector.<MP3Frame>();
			
			var frame:MP3Frame;
			while (decoder.bytesAvailable)
			{
				frame = new MP3Frame();
				frame.decode(decoder);
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
			for (var i:int = 0, lenght = _frames.length; i < lenght; i++)
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
	}
}