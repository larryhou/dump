package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.sound.mp3.id3.encoding.ID3Encoding;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 2:59:23 AM
	 */
	public class ID3TextFrame extends ID3Frame
	{
		public var encoding:uint;
		public var content:String;
		
		/**
		 * 构造函数
		 * create a [ID3TextFrame] object
		 */
		public function ID3TextFrame()
		{
			
		}	
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeInside(decoder:FileDecoder):void
		{
			encoding = bytes.readUnsignedByte();
			content = bytes.readMultiByte(bytes.bytesAvailable, ID3Encoding.type2charset(encoding));
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
			result.@content = content;
			return result.toXMLString();
		}
	}
}