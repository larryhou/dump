package com.larrio.dump.model.colors
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 24为颜色值
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:25:44 PM
	 */
	public class Pix24Color extends RGBColor
	{
		/**
		 * 构造函数
		 * create a [Pix24Color] object
		 */
		public function Pix24Color()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			assertTrue(decoder.readUI8() == 0);
			super.decode(decoder);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(0);
			super.encode(encoder);
		}		
	}
}