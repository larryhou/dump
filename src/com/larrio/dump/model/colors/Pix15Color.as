package com.larrio.dump.model.colors
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 15位颜色值
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:21:18 PM
	 */
	public class Pix15Color extends RGBColor
	{
		/**
		 * 构造函数
		 * create a [Pix15Color] object
		 */
		public function Pix15Color()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			assertTrue(decoder.readUB(1) == 0);
			
			_red = decoder.readUB(5);
			_green = decoder.readUB(5);
			_blue = decoder.readUB(5);
			
			_rgb = _red / ((1 << 5) - 1) * 0xFF << 16;
			_rgb |= _green / ((1 << 5) - 1) * 0xFF << 8;
			_rgb |= _blue / ((1 << 5) - 1) * 0xFF;
			_value = _rgb;
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(0, 1);
			encoder.writeUB(_red, 5);
			encoder.writeUB(_green, 5);
			encoder.writeUB(_blue, 5);
			encoder.flush();
		}	
	}
}