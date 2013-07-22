package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.sound.mp3.id3.encoding.ID3Encoding;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 3:26:19 AM
	 */
	public class ID3UserLinkFrame extends ID3LinkFrame
	{
		public var encoding:uint;
		public var description:String;
		
		/**
		 * 构造函数
		 * create a [ID3UserLinkFrame] object
		 */
		public function ID3UserLinkFrame()
		{
			
		}
		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeInside(decoder:FileDecoder):void
		{
			encoding = decoder.readUI8();
			
			var length:uint;
			var offset:uint = decoder.position;
			while (decoder.readUnsignedByte()) continue;
			
			length = decoder.position - 1 - offset;
			
			decoder.position = offset;
			description = decoder.readMultiByte(length, ID3Encoding.type2charset(encoding));
			
			decoder.readUnsignedByte();
			if (decoder[decoder.position] == 0x00) decoder.position++;
			
			url = decoder.readMultiByte(decoder.bytesAvailable, ID3Encoding.type2charset(ID3Encoding.ISO_8859_1));
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeInside(encoder:FileEncoder):void
		{
			encoder.writeUI8(encoding);
			encoder.writeMultiByte(description, ID3Encoding.type2charset(encoding));
			
			encoder.writeByte(0);
			if (encoding == ID3Encoding.UNICODE || encoding == ID3Encoding.UNICODE_BIG_ENDIAN)
			{
				encoder.writeByte(0);
			}
			
			encoder.writeMultiByte(url, ID3Encoding.type2charset(ID3Encoding.ISO_8859_1));
		}
	}
}