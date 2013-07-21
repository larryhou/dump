package com.larrio.dump.model.sound.mp3.id3.frames
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 3:26:19 AM
	 */
	public class ID3UserLinkFrame extends ID3LinkFrame
	{
		public var encoding:uint;
		public var description:String;
		
		/**
		 * 构造函数
		 * create a [ID3UserLinkFrame] object
		 */
		public function ID3UserLinkFrame()
		{
			
		}
		
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeInside(decoder:FileDecoder):void
		{
			super.decodeInside(decoder);
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