package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
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
			url = data.readUTF();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeInside(encoder:FileEncoder):void
		{
			super.encodeInside(encoder);
		}
	}
}