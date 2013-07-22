package com.larrio.dump.model.sound.mp3.id3
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.sound.mp3.id3.frames.ID3Frame;
	import com.larrio.dump.model.sound.mp3.id3.frames.ID3FrameFactory;
	import com.larrio.dump.model.sound.mp3.id3.frames.headers.ID3FrameHeaderFactory;
	import com.larrio.dump.model.sound.mp3.id3.headers.ID3ExtendHeader;
	import com.larrio.dump.model.sound.mp3.id3.headers.ID3Footer;
	import com.larrio.dump.model.sound.mp3.id3.headers.ID3Header;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * ID3 v2.4.0
	 * @author larryhou
	 * @createTime Jul 4, 2013 2:38:05 PM
	 */
	public class ID3Tag implements ICodec
	{			
		public var data:ByteArray;
		public var header:ID3Header;
		public var extendHeader:ID3ExtendHeader;
		
		public var frames:Vector.<ID3Frame>;
		
		public var padding:ByteArray;
		public var footer:ID3Footer;
		
		public var dict:Dictionary;
		
		/**
		 * 构造函数
		 * create a [ID3Tag] object
		 */
		public function ID3Tag()
		{
			
		}
		
		private function reset():void
		{
			extendHeader = null;
			footer = null;
		}
		
		/**
		 * 判定当前位置是否为ID3Tag
		 * @param source	字节数据
		 */		
		public static function verify(source:ByteArray):Boolean
		{
			return ID3Header.verify(source);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{	
			reset();
			
			header = new ID3Header();
			header.decode(decoder);
			
			data = new ByteArray();
			if (header.length)
			{
				decoder.readBytes(data, 0, header.length);
			}
			
			decoder = new FileDecoder();
			if (header.flags & ID3Header.UNSYNCHRONISATION)
			{
				decoder.writeBytes(unsynchronise(data));
			}
			else
			{
				decoder.writeBytes(data);
			}
			
			decoder.position = 0;
			decodeInside(decoder);
		}
		
		private function decodeInside(decoder:FileDecoder):void
		{
			var position:uint;			
			if (header.flags & ID3Header.EXTEND_HEADER)
			{
				extendHeader = new ID3ExtendHeader();
				extendHeader.decode(decoder);
			}
			
			dict = new Dictionary();
			frames = new Vector.<ID3Frame>();
			
			var frame:ID3Frame,identifier:String;
			while (decoder.bytesAvailable)
			{
				position = decoder.position;
				identifier = frameVerify(decoder);
				
				if (identifier)
				{
					frame = ID3FrameFactory.create(identifier);
					frame.header = ID3FrameHeaderFactory.create(header.majorVersion);
					
					frame.decode(decoder);
					frames.push(frame);
					
					if (!dict[identifier]) dict[identifier] = [];
					dict[identifier].push(frame);
				}
				
				if (header.flags & ID3Header.FOOTER)
				{
					if (ID3Footer.verify(decoder))
					{
						footer = new ID3Footer();
						footer.decode(decoder);
					}
				}
				
				if (decoder.position == position)
				{
					padding = new ByteArray();
					decoder.readBytes(padding, 0, decoder.bytesAvailable);
				}
			}
			
			trace(this);
		}
		
		private function frameVerify(bytes:ByteArray):String
		{
			var MIN_HEADER_SIZE:uint;
			var NUM_IDENTIFIER_BYTES:uint;
			switch (header.majorVersion)
			{
				case 0x03:
				case 0x04:
				{
					MIN_HEADER_SIZE = 10;
					NUM_IDENTIFIER_BYTES = 4;
					break;
				}
					
				default:
				{
					MIN_HEADER_SIZE = 6;
					NUM_IDENTIFIER_BYTES = 3;
					break;
				}
			}
			
			var identifier:String;
			if (bytes.bytesAvailable >= MIN_HEADER_SIZE + 1)
			{
				identifier = bytes.readUTFBytes(NUM_IDENTIFIER_BYTES);
				bytes.position -= NUM_IDENTIFIER_BYTES;
				
				if (!identifier.match(/^[A-Z0-9]+$/)) identifier = null;
			}
			
			return identifier;
		}
		
		private function synchronise(bytes:ByteArray):ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			for (var i:int = 0; i < bytes.length - 2; i++)
			{
				buffer.writeByte(bytes[i]);
				if (bytes[i] == 0xFF && bytes[i + 1] == 0x00)
				{
					if (bytes[i + 2] == 0x00 || (bytes[i + 2] & 0xE0) == 0xE0) i++;
				}				
			}
			
			buffer.writeByte(bytes[i]);
			if (bytes[i] != 0xFF) buffer.writeByte(bytes[i + 1]);
			
			return buffer;
		}
		
		private function unsynchronise(bytes:ByteArray):ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			for (var i:int = 0; i < bytes.length - 1; i++)
			{
				buffer.writeByte(bytes[i]);
				if (bytes[i] == 0xFF)
				{
					if ((bytes[i + 1] & 0xE0) == 0xE0 || bytes[i + 1] == 0x00)
					{
						buffer.writeByte(0);
					}
				}
			}
			
			buffer.writeByte(buffer[i]);
			if (bytes[i] == 0xFF) buffer.writeByte(0);
			
			return buffer;
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var buffer:FileEncoder;
			
			buffer = new FileEncoder();
			encodeInside(buffer);
			
			var bytes:ByteArray;
			if (header.flags & ID3Header.UNSYNCHRONISATION)
			{
				bytes = synchronise(buffer);
			}
			
			header.length = bytes.length;
			
			header.encode(encoder);
			encoder.writeBytes(bytes);
		}
			
		private function encodeInside(encoder:FileEncoder):void
		{
			if (header.flags & ID3Header.EXTEND_HEADER)
			{
				extendHeader.encode(encoder);
			}
			
			for (var i:int = 0; i < frames.length; i++)
			{
				frames[i].encode(encoder);
			}
			
			if (header.flags & ID3Header.FOOTER)
			{
				footer.encode(encoder);
			}
			else
			if (padding)
			{
				encoder.writeBytes(padding);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<id3tag/>");
			for (var i:int = 0; i < frames.length; i++)
			{
				result.appendChild(new XML(frames[i].toString()));
			}
			
			return result.toXMLString();	
		}

	}
}