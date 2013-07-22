package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.sound.mp3.id3.encoding.ID3Encoding;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 11:57:08 PM
	 */
	public class ID3PRIVFrame extends ID3Frame
	{
		public var owner:String;
		public var data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [ID3PRIVFrame] object
		 */
		public function ID3PRIVFrame()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeInside(decoder:FileDecoder):void
		{
			var length:uint;
			var offset:uint = decoder.position;
			while (decoder.readUnsignedByte()) continue;
			
			length = decoder.position - 1;
			
			decoder.position = offset;
			owner = decoder.readMultiByte(length, ID3Encoding.type2charset(ID3Encoding.ISO_8859_1));
			
			decoder.readUnsignedByte();
			
			data = new ByteArray();
			decoder.readBytes(data);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeInside(encoder:FileEncoder):void
		{
			encoder.writeMultiByte(owner, ID3Encoding.type2charset(ID3Encoding.ISO_8859_1));
			encoder.writeByte(0);
			encoder.writeBytes(data);
		}
	}
}