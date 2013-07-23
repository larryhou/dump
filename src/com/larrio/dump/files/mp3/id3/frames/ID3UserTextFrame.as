package com.larrio.dump.files.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.files.mp3.id3.encoding.ID3Encoding;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 3:27:24 AM
	 */
	public class ID3UserTextFrame extends ID3TextFrame
	{
		public var description:String;
		
		/**
		 * 构造函数
		 * create a [ID3UserTextFrame] object
		 */
		public function ID3UserTextFrame()
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
			
			length = (decoder.position - 1) - offset;
			
			decoder.position = offset;
			description = decoder.readMultiByte(length, ID3Encoding.type2charset(encoding));
			
			decoder.readUnsignedByte();
			if (!decoder.readUnsignedByte()) decoder.position++;
			
			content = decoder.readMultiByte(decoder.bytesAvailable, ID3Encoding.type2charset(encoding));
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
			
			encoder.writeMultiByte(content, ID3Encoding.type2charset(encoding));
		}
		
		override public function toString():String
		{
			var result:XML = new XML(super.toString());
			result.@description = description;
			return result.toXMLString()
		}
	}
}