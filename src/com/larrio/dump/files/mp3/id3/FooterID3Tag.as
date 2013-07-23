package com.larrio.dump.files.mp3.id3
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 21, 2013 4:21:19 PM
	 */
	public class FooterID3Tag implements ICodec
	{
		private static const NUM_IDENTIFIER_BYES:uint = 3;
		
		public var identifier:String;
		
		public var content:String;
		
		/**
		 * 构造函数
		 * create a [ID3FooterTag] object
		 */
		public function FooterID3Tag()
		{
			
		}
		
		public static function verify(bytes:ByteArray):Boolean
		{
			if (bytes.bytesAvailable < NUM_IDENTIFIER_BYES) return false;
			var str:String = bytes.readMultiByte(NUM_IDENTIFIER_BYES, "utf-8");
			bytes.position -= NUM_IDENTIFIER_BYES;
			
			return str == "TAG";
		}
		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			identifier = decoder.readMultiByte(NUM_IDENTIFIER_BYES, "utf-8");
			content = "";
			
			var byte:uint;
			var buffer:ByteArray;
			while (decoder.bytesAvailable)
			{
				byte = decoder.readUI8();
				if (!byte) 
				{
					if (buffer)
					{
						buffer.position = 0;
						content += buffer.readMultiByte(buffer.bytesAvailable, "utf-8") + ";";
						buffer = null;
					}
					continue;
				}
				
				if (!buffer) buffer = new ByteArray();
				buffer.writeByte(byte);
			}
			
			if (buffer)
			{
				buffer.position = 0;
				content += buffer.readMultiByte(buffer.bytesAvailable, "utf-8");
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			return;
			identifier = identifier.substr(0, NUM_IDENTIFIER_BYES);
			
			encoder.writeMultiByte(identifier, "utf-8");
			encoder.writeMultiByte(content, "utf-8");
			
			var data:ByteArray;
			data = new ByteArray();
			data.writeUTF(content);
			while (data.length < 128) data.writeByte(0);
			encoder.writeBytes(data);
		}
		
		public function toString():String
		{
			var result:XML = new XML("<TAG/>");
			result.@content = content;
			return result.toXMLString();
		}
	}
}