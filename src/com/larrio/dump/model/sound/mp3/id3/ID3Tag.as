package com.larrio.dump.model.sound.mp3.id3
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.sound.mp3.id3.frames.ID3Frame;
	import com.larrio.dump.model.sound.mp3.id3.header.ID3ExtendHeader;
	import com.larrio.dump.model.sound.mp3.id3.header.ID3Footer;
	import com.larrio.dump.model.sound.mp3.id3.header.ID3Header;
	
	import flash.utils.ByteArray;
	
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
		
		public var footer:ID3Footer;
		
		/**
		 * 构造函数
		 * create a [ID3Tag] object
		 */
		public function ID3Tag()
		{
			
		}
		
		private function reset():void
		{
			header = null;
			data = null;
			
			extendHeader = null;
			frames = null;
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
			decoder.writeBytes(data);
			decoder.position = 0;
			decodeBody(decoder);
		}
		
		private function decodeBody(decoder:FileDecoder):void
		{
			if (header.flags & ID3Header.EXTEND_HEADER)
			{
				extendHeader = new ID3ExtendHeader();
				extendHeader.decode(decoder);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			header.length = data.length;
			header.encode(encoder);
			
			encodeBody(encoder);
		}
		
		private function encodeBody(encoder:FileEncoder):void
		{
			if (header.length)
			{
				encoder.writeBytes(data);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "<ID3Tag/>";	
		}

	}
}