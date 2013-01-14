package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.math.fixed;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 1:56:36 PM
	 */
	public class LineStyle2 extends LineStyle
	{
		private var _startCapStyle:uint;
		private var _joinStyle:uint;
		
		private var _hasFillFlag:uint;
		private var _noHScaleFlag:uint;
		private var _noVScaleFlag:uint;
		private var _pixelHintingFlag:uint;
		
		private var _noClose:uint;
		private var _endCapStyle:uint;
		private var _miterLimitFactor:uint;
		private var _style:FillStyle;
		
		/**
		 * 构造函数
		 * create a [LineStyle2] object
		 */
		public function LineStyle2(shape:uint)
		{
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			_width = decoder.readUI16();
			_startCapStyle = decoder.readUB(2);
			_joinStyle = decoder.readUB(2);
			
			_hasFillFlag = decoder.readUB(1);
			_noHScaleFlag = decoder.readUB(1);
			_noVScaleFlag = decoder.readUB(1);
			_pixelHintingFlag = decoder.readUB(1);
			
			assertTrue(decoder.readUB(5) == 0);
			
			_noClose = decoder.readUB(1);
			_endCapStyle = decoder.readUB(2);
			
			if (_joinStyle == 2)
			{
				_miterLimitFactor = decoder.readUI16();
			}
			
			if (_hasFillFlag)
			{
				_style = new FillStyle(_shape);
				_style.decode(decoder);
			}
			else
			{
				_color = new RGBAColor();
				_color.decode(decoder);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI16(_width);
			encoder.writeUB(_startCapStyle, 2);
			encoder.writeUB(_joinStyle, 2);
			
			encoder.writeUB(_hasFillFlag, 1);
			encoder.writeUB(_noHScaleFlag, 1);
			encoder.writeUB(_noVScaleFlag, 1);
			encoder.writeUB(_pixelHintingFlag, 1);
			
			encoder.writeUB(0, 5);
			
			encoder.writeUB(_noClose, 1);
			encoder.writeUB(_endCapStyle, 2);
			
			if (_joinStyle == 2)
			{
				encoder.writeUI16(_miterLimitFactor);
			}
			
			if (_hasFillFlag)
			{
				_style.encode(encoder);
			}
			else
			{
				_color.encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<LineStyle2/>");
			result.@width = _width / 20;
			result.@startCapStyle = _startCapStyle;
			result.@joinStyle = _joinStyle;
			result.@noClose = _noClose;
			result.@endCapStyle = _endCapStyle;
			
			if (_joinStyle == 2)
			{
				result.@miterLimitFactor = fixed(_miterLimitFactor, 8, 8)
			}
			
			if (_hasFillFlag)
			{
				result.appendChild(new XML(_style.toString()));
			}
			else
			{
				result.appendChild(new XML(_color.toString()));
			}
			
			return result.toXMLString();	
		}
		

		/**
		 * Start cap style
		 * 0 = Round cap
		 * 1 = No cap
		 * 2 = Square cap
		 */		
		public function get startCapStyle():uint { return _startCapStyle; }

		/**
		 * Join style
		 * 0 = Round join
		 * 1 = Bevel join
		 * 2 = Miter join
		 */		
		public function get joinStyle():uint { return _joinStyle; }

		/**
		 * If 1, stroke will not be closed if the stroke’s last point matches its first point. 
		 * Flash Player will apply caps instead of a join.
		 */		
		public function get noClose():uint { return _noClose; }

		/**
		 * End cap style
		 * 0 = Round cap
		 * 1 = No cap
		 * 2 = Square cap
		 */		
		public function get endCapStyle():uint { return _endCapStyle; }

		/**
		 * Miter limit factor is an 8.8 fixed-point value.
		 */		
		public function get miterLimitFactor():uint { return _miterLimitFactor; }

		/**
		 * Fill style for this stroke.
		 */		
		public function get style():FillStyle { return _style; }

		/**
		 * 没有水平缩放 
		 */		
		public function get noHScaleFlag():uint { return _noHScaleFlag; }

		/**
		 * 没有竖向缩放
		 */		
		public function get noVScaleFlag():uint { return _noVScaleFlag; }

		/**
		 * 是否有hinting
		 */		
		public function get pixelHintingFlag():uint { return _pixelHintingFlag; }

		/**
		 * 是否有填充
		 */		
		public function get hasFillFlag():uint { return _hasFillFlag; }

	}
}