package com.larrio.dump.model.colors
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 5:44:59 PM
	 */
	public class ARGBColor extends RGBColor
	{
		private var _alpha:uint;
		
		/**
		 * 构造函数
		 * create a [ARGBColor] object
		 */
		public function ARGBColor()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			_alpha = decoder.readUI8();
			
			super.decode(decoder);
			
			_rgb = _red << 16 | _green << 8 | _blue;
			_value = _alpha << 24 | _rgb;
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(_alpha);
			
			super.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML(super.toString());
			result.@alpha = _alpha.toString(16).toUpperCase();
			return result.toXMLString();	
		}
	}
}