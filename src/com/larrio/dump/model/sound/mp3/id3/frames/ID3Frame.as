package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.sound.mp3.id3.frames.headers.ID3FrameHeader;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 12:36:36 AM
	 */
	public class ID3Frame implements ICodec
	{
		public var header:ID3FrameHeader;
		
		public var bytes:ByteArray;
		
		/**
		 * 构造函数
		 * create a [ID3Frame] object
		 */
		public function ID3Frame()
		{
			
		}
				
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			header.decode(decoder);
			
			bytes = new ByteArray();
			decoder.readBytes(bytes, 0, header.length);
			
			decoder = new FileDecoder();
			decoder.writeBytes(bytes);
			decoder.position = 0;
			
			decodeInside(decoder);
		}
		
		protected function decodeInside(decoder:FileDecoder):void
		{
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			header.encode(encoder);
			encodeInside(encoder);
		}
		
		protected function encodeInside(encoder:FileEncoder):void
		{
			encoder.writeBytes(bytes);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<id3frame/>");
			result.@identifier = header.identifier;
			return result.toXMLString();	
		}
	}
}