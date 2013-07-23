package com.larrio.dump.files.mp3.id3.frames.headers
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 1:47:29 AM
	 */
	public class ID3v23FrameHeader extends ID3FrameHeader
	{
		/**
		 * 构造函数
		 * create a [ID3v2FrameHeader] object
		 */
		public function ID3v23FrameHeader()
		{
			
		}
		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			identifier = decoder.readUTFBytes(4);
			length = readInteger(decoder, 4);
			flags = decoder.readUI16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUTF(identifier);
			writeInteger(length, encoder, 4);
			encoder.writeUI16(flags);
		}
	}
}