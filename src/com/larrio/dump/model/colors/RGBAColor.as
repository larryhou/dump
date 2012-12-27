package com.larrio.dump.model.colors
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 5:44:42 PM
	 */
	public class RGBAColor extends RGBColor
	{
		private var _alpha:uint;
		
		/**
		 * 构造函数
		 * create a [RGBAColor] object
		 */
		public function RGBAColor()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			_alpha = decoder.readUI8();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			super.encode(encoder);
			
			encoder.writeUI8(_alpha);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<RGBAColor/>");
			result.@red = _red;
			result.@green = _green;
			result.@blue = _blue;
			result.@alpha = _alpha;
			return result.toXMLString();	
		}
		
	}
}