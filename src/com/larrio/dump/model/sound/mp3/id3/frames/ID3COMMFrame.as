package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.sound.mp3.id3.encoding.ID3Encoding;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 23, 2013 12:02:48 AM
	 */
	public class ID3COMMFrame extends ID3Frame
	{
		public var encoding:uint;
		
		public var language:String;
		
		public var description:String;
		public var content:String;
		
		/**
		 * 构造函数
		 * create a [ID3COMMFrame] object
		 */
		public function ID3COMMFrame()
		{
			
		}
		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeInside(decoder:FileDecoder):void
		{
			encoding = decoder.readUI8();
			language = decoder.readUTFBytes(3);
			
			var length:uint;
			var offset:uint = decoder.position;
			while (decoder.readUnsignedByte()) continue;
			
			length = decoder.position - 1 - offset;
			
			decoder.position = offset;
			description = decoder.readMultiByte(length, ID3Encoding.type2charset(encoding));
				
			decoder.readUnsignedByte();
			if (decoder[decoder.position] == 0x00) decoder.position++;
			
			content = decoder.readMultiByte(decoder.bytesAvailable, ID3Encoding.type2charset(encoding));
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeInside(encoder:FileEncoder):void
		{
			encoder.writeUI8(encoding);
			encoder.writeUTF(language);
			
			encoder.writeMultiByte(description, ID3Encoding.type2charset(encoding));
			
			encoder.writeByte(0);
			if (encoding == ID3Encoding.UNICODE || encoding == ID3Encoding.UNICODE_BIG_ENDIAN)
			{
				encoder.writeByte(0);
			}
			
			encoder.writeMultiByte(content, ID3Encoding.type2charset(encoding));
		}
		
		override public function toString():String
		{
			var result:XML = new XML(super.toString());
			result.@encoding = ID3Encoding.type2charset(encoding);
			result.@language = language;
			result.@description = description;
			result.@content = content;
			return result.toXMLString();
		}
	}
}