package com.larrio.dump.model.sound.mp3.id3.frames.headers
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 1:52:36 AM
	 */
	public class ID3FrameHeader implements ICodec
	{
		public var identifier:String;
		
		public var length:uint;
		
		public var flags:uint;
		
		/**
		 * 构造函数
		 * create a [ID3FrameHeader] object
		 */
		public function ID3FrameHeader()
		{
			
		}		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			
		}   
		
		protected final function readInteger(bytes:ByteArray, num:uint):uint
		{
			var result:uint = 0;
			while (num > 0)
			{
				result |= bytes.readUnsignedByte() << (num - 1) * 8;
				num--;
			}
			
			return result;
		}
		
		protected final function writeInteger(value:uint, bytes:ByteArray, num:uint):void
		{
			var shift:uint;
			while (num > 0)
			{
				shift = (num - 1) * 8;
				bytes.writeByte((value >>> shift) & 0xFF);
				num--;
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}
	}
}