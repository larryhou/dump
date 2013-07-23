package com.larrio.dump.files.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.files.mp3.id3.encoding.ID3Encoding;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 11:11:11 PM
	 */
	public class ID3APICFrame extends ID3Frame
	{
		public var encoding:uint;
		public var mimeType:String;
		public var type:uint;
		public var description:String;
		public var data:ByteArray;
		
		/**
		 * 构造函数
		 * create a [ID3APICFrame] object
		 */
		public function ID3APICFrame()
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
			mimeType = decoder.readMultiByte(length, ID3Encoding.charset(ID3Encoding.ISO_8859_1));
			
			decoder.readUnsignedByte();
			type = decoder.readUI8();
			
			offset = decoder.position;
			while (decoder.readUnsignedByte()) continue;
			
			length = decoder.position - 1 - offset;
			
			decoder.position = offset;
			description = decoder.readMultiByte(length, ID3Encoding.charset(encoding));
			
			decoder.readUnsignedByte();
			if (decoder[decoder.position] == 0x00) decoder.position++;
			
			data = new ByteArray();
			decoder.readBytes(data);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeInside(encoder:FileEncoder):void
		{
			super.encodeInside(encoder);
		}
		
		private function formatType():String
		{
			switch (type)
			{
				case 0x00: return "Other";
				case 0x01: return "32x32 pixels 'file icon' (PNG only)";
				case 0x02: return "Other file icon";
				case 0x03: return "Cover (front)";
				case 0x04: return "Cover (back)";
				case 0x05: return "Leaflet page";
				case 0x06: return "Media (e.g. lable side of CD)";
				case 0x07: return "Lead artist/lead performer/soloist";
				case 0x08: return "Artist/performer";
				case 0x09: return "Conductor";
				case 0x0A: return "Band/Orchestra";
				case 0x0B: return "Composer";
				case 0x0C: return "Lyricist/text writer";
				case 0x0D: return "Recording Location";
				case 0x0E: return "During recording";
				case 0x0F: return "During performance";
				case 0x10: return "Movie/video screen capture";
				case 0x11: return "A bright coloured fish";
				case 0x12: return "Illustration";
				case 0x13: return "Band/artist logotype";
				case 0x14: return "Publisher/Studio logotype";
			}
			
			return "unknown";
		}
		
		override public function toString():String
		{
			var result:XML = new XML(super.toString());
			result.@encoding = ID3Encoding.charset(encoding);
			result.@mimeType = mimeType;
			result.@type = formatType();
			result.@description = description;
			result.@size = data.length;
			return result.toXMLString();
		}
	}
}