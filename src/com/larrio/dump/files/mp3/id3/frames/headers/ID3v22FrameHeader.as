package com.larrio.dump.files.mp3.id3.frames.headers
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 1:51:18 AM
	 */
	public class ID3v22FrameHeader extends ID3FrameHeader
	{
		/**
		 * 构造函数
		 * create a [ID3v22FrameHeader] object
		 */
		public function ID3v22FrameHeader()
		{
			
		}
		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			identifier = decoder.readUTFBytes(3);
			length = readInteger(decoder, 3);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUTF(identifier);
			writeInteger(length, encoder, 3);
		}
	}
}