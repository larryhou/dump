package com.larrio.dump.files.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.files.mp3.id3.encoding.ID3Encoding;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 3:23:53 AM
	 */
	public class ID3LinkFrame extends ID3Frame
	{
		public var url:String;
		
		/**
		 * 构造函数
		 * create a [ID3LinkFrame] object
		 */
		public function ID3LinkFrame()
		{
			
		}
				
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeInside(decoder:FileDecoder):void
		{
			url = decoder.readMultiByte(decoder.bytesAvailable, ID3Encoding.type2charset(ID3Encoding.ISO_8859_1));
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeInside(encoder:FileEncoder):void
		{
			encoder.writeMultiByte(url, ID3Encoding.type2charset(ID3Encoding.ISO_8859_1));
		}
		
		override public function toString():String
		{
			var result:XML = new XML(super.toString());
			result.@url = url;
			return result.toXMLString();
		}
	}
}