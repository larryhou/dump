package com.larrio.dump.model.colors
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.getQualifiedClassName;
	
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
		
		protected var _rgb:uint;
		protected var _value:uint;
		
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
			
			_rgb = _red << 16 | _green << 8 | _blue;
			_value = _rgb;
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
			var name:String = getQualifiedClassName(this).split("::")[1];
			
			var result:XML = new XML("<" + name + "/>");
			result.@red = _red.toString(16).toUpperCase();
			result.@green = _green.toString(16).toUpperCase();
			result.@blue = _blue.toString(16).toUpperCase();
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

		/**
		 * 颜色值
		 */		
		public function get value():uint { return _value; }

		/**
		 * RGB颜色值
		 */		
		public function get rgb():uint { return _rgb; }
		
	}
}