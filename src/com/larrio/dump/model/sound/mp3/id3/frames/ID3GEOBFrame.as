package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.sound.mp3.id3.encoding.ID3Encoding;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 11:43:38 PM
	 */
	public class ID3GEOBFrame extends ID3Frame
	{
		public var encoding:uint;
		public var mimeType:String;
		public var name:String;
		public var description:String;
		public var data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [ID3GEOBFrame] object
		 */
		public function ID3GEOBFrame()
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
			mimeType = decoder.readMultiByte(length, ID3Encoding.type2charset(ID3Encoding.ISO_8859_1));
			
			decoder.readUnsignedByte();
			
			offset = decoder.position;
			while (decoder.readUnsignedByte()) continue;
			length = decoder.position - 1 - offset;
			
			decoder.position = offset;
			name = decoder.readMultiByte(length, ID3Encoding.type2charset(encoding));
			
			decoder.readUnsignedByte();
			if (decoder[decoder.position] == 0x00) decoder.position++;
			
			offset = decoder.position;
			while (decoder.readUnsignedByte()) continue;
			length = decoder.position - 1 - offset;
			
			decoder.position = offset;
			description = decoder.readMultiByte(length, ID3Encoding.type2charset(encoding));
			
			decoder.readUnsignedByte();
			if (decoder[decoder.position]) decoder.position++;
			
			data = new ByteArray();
			decoder.readBytes(data);
			
			trace(this);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeInside(encoder:FileEncoder):void
		{
			super.encodeInside(encoder);
		}
		
		override public function toString():String
		{
			var result:XML = new XML(super.toString());
			result.@encoding = ID3Encoding.type2charset(encoding);
			result.@mimeType = mimeType;
			result.@name = name;
			result.@description = description;
			result.@size = data.length;
			return result.toXMLString();
		}
	}
}