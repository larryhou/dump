package com.larrio.dump.model.morph
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.colors.RGBAColor;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 2:15:28 PM
	 */
	public class MorphLineStyle implements ICodec
	{
		protected var _startWidth:uint;
		protected var _endWidth:uint;
		
		protected var _startColor:RGBAColor;
		protected var _endColor:RGBAColor;
		
		/**
		 * 构造函数
		 * create a [MorphLineStyle] object
		 */
		public function MorphLineStyle()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_startWidth = decoder.readUI16();
			_endWidth = decoder.readUI16();
			
			_startColor = new RGBAColor();
			_startColor.decode(decoder);
			
			_endColor = new RGBAColor();
			_endColor.decode(decoder);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI16(_startWidth);
			encoder.writeUI16(_endWidth);
			
			_startColor.encode(encoder);
			_endColor.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<MorphLineStyle/>");
			result.@startWidth = _startWidth / 20;
			result.@endWidth = _endWidth / 20;
			
			var item:XML;
			item = new XML("<startColor/>");
			item.appendChild(new XML(_startColor.toString()));
			result.appendChild(item);
			
			item = new XML("<endColor/>");
			item.appendChild(new XML(_endColor.toString()));
			result.appendChild(item);
			
			return result.toXMLString();	
		}

		/**
		 * Width of line in start shape in twips.
		 */		
		public function get startWidth():uint { return _startWidth; }

		/**
		 * Width of line in end shape in twips.
		 */		
		public function get endWidth():uint { return _endWidth; }

		/**
		 * Color value including alpha channel information for start shape.
		 */		
		public function get startColor():RGBAColor { return _startColor; }

		/**
		 * Color value including alpha channel information for end shape.
		 */		
		public function get endColor():RGBAColor { return _endColor; }

	}
}