package com.larrio.dump.model.bitmap
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:25:44 PM
	 */
	public class Pix24Color extends Pix15Color
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
			
			_red = decoder.readUI8();
			_green = decoder.readUI8();
			_blue = decoder.readUI8();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(0);
			encoder.writeUI8(_red);
			encoder.writeUI8(_green);
			encoder.writeUI8(_blue);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			return super.toString().replace(/Pix15Color/g, "Pix24Color");	
		}
		
	}
}