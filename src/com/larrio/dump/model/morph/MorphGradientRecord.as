package com.larrio.dump.model.morph
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.colors.RGBAColor;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 1:30:58 PM
	 */
	public class MorphGradientRecord implements ICodec
	{
		private var _startRatio:uint;
		private var _startColor:RGBAColor;
		
		private var _endRatio:uint;
		private var _endColor:RGBAColor;
		
		/**
		 * 构造函数
		 * create a [MorphGradientRecord] object
		 */
		public function MorphGradientRecord()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_startRatio = decoder.readUI8();
			_startColor = new RGBAColor();
			_startColor.decode(decoder);
			
			_endRatio = decoder.readUI8();
			_endColor = new RGBAColor();
			_endColor.decode(decoder);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(_startRatio);
			_startColor.encode(encoder);
			
			encoder.writeUI8(_endRatio);
			_endColor.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var item:XML;
			var result:XML = new XML("<MorphGradientRecord/>");
			
			item = new XML("<startColor/>");
			item.@ratio = _startRatio / 256;
			result.appendChild(item);
			
			item = new XML("<endColor/>");
			item.@ratio = _endRatio / 256;
			result.appendChild(item);
			
			return result.toXMLString();	
		}

		/**
		 * Ratio value for start shape.
		 */		
		public function get startRatio():uint { return _startRatio; }

		/**
		 * Color of gradient for start shape.
		 */		
		public function get startColor():RGBAColor { return _startColor; }

		/**
		 * Ratio value for end shape.
		 */		
		public function get endRatio():uint { return _endRatio; }

		/**
		 * Color of gradient for end shape.
		 */		
		public function get endColor():RGBAColor { return _endColor; }

	}
}