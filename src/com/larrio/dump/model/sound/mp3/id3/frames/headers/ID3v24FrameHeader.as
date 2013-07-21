package com.larrio.dump.model.sound.mp3.id3.frames.headers
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 1:47:45 AM
	 */
	public class ID3v24FrameHeader extends ID3FrameHeader
	{
		/**
		 * 构造函数
		 * create a [ID3v24FrameHeader] object
		 */
		public function ID3v24FrameHeader()
		{
			
		}
		
		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			identifier = decoder.readUTFBytes(4);
			length = decoder.readSynchsafe();
			flags = decoder.readUI16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUTF(identifier);
			encoder.writeSynchsafe(length);
			encoder.writeUI16(flags);
		}
	}
}