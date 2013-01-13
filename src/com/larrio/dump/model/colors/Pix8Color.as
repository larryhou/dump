package com.larrio.dump.model.colors
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 8位颜色值
	 * @author larryhou
	 * @createTime Jan 13, 2013 12:42:10 AM
	 */
	public class Pix8Color extends RGBColor
	{
		/**
		 * 构造函数
		 * create a [Pix8Color] object
		 */
		public function Pix8Color()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			_red = decoder.readUB(3);
			_green = decoder.readUB(3);
			_blue = decoder.readUB(2);
			
			decoder.byteAlign();
			
			_rgb = _red / ((1 << 3) - 1) * 0xFF << 16;
			_rgb |= _green / ((1 << 3) - 1) * 0xFF << 8;
			_rgb |= _blue / ((1 << 2) - 1) * 0xFF;
			
			_value = _rgb;
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_red, 3);
			encoder.writeUB(_green, 3);
			encoder.writeUB(_blue, 2);
			
			encoder.flush();
		}
		
	}
}