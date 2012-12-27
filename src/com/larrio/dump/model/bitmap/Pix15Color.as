package com.larrio.dump.model.bitmap
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 8:21:18 PM
	 */
	public class Pix15Color implements ICodec
	{
		protected var _red:uint;
		protected var _green:uint;
		protected var _blue:uint;
		
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
		public function decode(decoder:FileDecoder):void
		{
			assertTrue(decoder.readUB(1) == 0);
			
			_red = decoder.readUB(5);
			_green = decoder.readUB(5);
			_blue = decoder.readUB(5);
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(0, 1);
			encoder.writeUB(_red, 5);
			encoder.writeUB(_green, 5);
			encoder.writeUB(_blue, 5);
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<Pix15Color/>");
			result.@red = _red;
			result.@green = _green;
			result.@blue = _blue;
			return result.toXMLString();	
		}

		/**
		 * red value
		 */		
		public function get red():uint { return _red; }

		/**
		 * green value
		 */		
		public function get green():uint { return _green; }

		/**
		 * blue value
		 */		
		public function get blue():uint { return _blue; }

	}
}