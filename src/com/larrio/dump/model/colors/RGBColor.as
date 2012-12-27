package com.larrio.dump.model.colors
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 5:44:30 PM
	 */
	public class RGBColor implements ICodec
	{
		protected var _red:uint;
		protected var _green:uint;
		protected var _blue:uint;
		
		/**
		 * 构造函数
		 * create a [RGBColor] object
		 */
		public function RGBColor()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_red = decoder.readUI8();
			_green = decoder.readUI8();
			_blue = decoder.readUI8();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(_red);
			encoder.writeUI8(_green);
			encoder.writeUI8(_blue);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<RGBColor/>");
			result.@red = _red;
			result.@green = _green;
			result.@blue = _blue;
			return result.toXMLString();	
		}

		/**
		 * 红色通道
		 */		
		public function get red():uint { return _red; }

		/**
		 * 绿色通道
		 */		
		public function get green():uint { return _green; }

		/**
		 * 蓝色通道
		 */		
		public function get blue():uint { return _blue; }

	}
}