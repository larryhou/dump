package com.larrio.dump.model.sound.mp3.id3.header
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 21, 2013 2:48:48 PM
	 */
	public class ID3Header implements ICodec
	{
		// ID3Header Flags
		//----------------------------
		public static const UNSYNCHRONISATION:uint = 1 << 7;
		public static const EXTEND_HEADER:uint = 1 << 6;
		public static const EXPERIMENTAL_INDICATOR:uint = 1 << 5;
		public static const FOOTER:uint = 1 << 4;
		
		// protected constants
		//----------------------------
		protected static const NUM_IDENTIFIER_BYTES:uint = 3;
		
		public var identifier:String;
		
		public var majorVersion:uint;
		
		public var minorVersion:uint;
		
		public var flags:uint;
		
		public var length:uint;
		
		/**
		 * 构造函数
		 * create a [ID3Header] object
		 */
		public function ID3Header()
		{
			
		}		
		
		public static function verify(bytes:ByteArray):Boolean
		{
			if (bytes.bytesAvailable < NUM_IDENTIFIER_BYTES) return false;
			
			var str:String = bytes.readMultiByte(NUM_IDENTIFIER_BYTES, "utf-8");
			bytes.position -= NUM_IDENTIFIER_BYTES;
			return str == "ID3";
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			identifier = decoder.readMultiByte(NUM_IDENTIFIER_BYTES, "utf-8");
			majorVersion = decoder.readUI8();
			minorVersion = decoder.readUI8();
			flags = decoder.readUI8();
			length = decoder.readSynchsafe();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			identifier = identifier.substr(0, NUM_IDENTIFIER_BYTES);
			encoder.writeMultiByte(identifier, "utf-8");
			encoder.writeUI8(majorVersion);
			encoder.writeUI8(minorVersion);
			encoder.writeUI8(flags);
			encoder.writeSynchsafe(length);
		}
		
	}
}