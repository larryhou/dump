package com.larrio.dump.model.filters
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.RGBAColor;
	import com.larrio.dump.model.types.FilterType;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 10:37:02 PM
	 */
	public class ConvolutionFilter implements ICodec
	{
		private var _matrixX:uint;
		private var _matrixY:uint;
		
		private var _divisor:Number;
		private var _bias:Number;
		
		private var _matrix:Vector.<Number>;
		
		private var _color:RGBAColor;
		
		private var _clamp:uint;
		private var _preserveAlpha:uint;
		
		/**
		 * 构造函数
		 * create a [ConvolutionFilter] object
		 */
		public function ConvolutionFilter()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_matrixX = decoder.readUI8();
			_matrixY = decoder.readUI8();
			
			_divisor = decoder.readFloat();
			_bias = decoder.readFloat();
			
			var length:uint = _matrixX * _matrixY;
			_matrix = new Vector.<Number>(length, true);
			for (var i:int = 0; i < length; i++)
			{
				_matrix[i] = decoder.readFloat();
			}
			
			_color = new RGBAColor();
			_color.decode(decoder);
			
			assertTrue(decoder.readUB(6) == 0)
			
			_clamp = decoder.readUB(1);
			_preserveAlpha = decoder.readUB(1);
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(_matrixX);
			encoder.writeUI8(_matrixY);
			
			encoder.writeFloat(_divisor);
			encoder.writeFloat(_bias);
			
			var length:uint = _matrix.length;
			for (var i:int = 0; i < length; i++)
			{
				encoder.writeFloat(_matrix[i]);
			}
			
			_color.encode(encoder);
			
			encoder.writeUB(6);
			encoder.writeUB(_clamp, 1);
			encoder.writeUB(_preserveAlpha, 1);
			encoder.flush();
		}

		/**
		 * Horizontal matrix size
		 */		
		public function get matrixX():uint { return _matrixX; }

		/**
		 * Vertical matrix size
		 */		
		public function get matrixY():uint { return _matrixY; }

		/**
		 * Divisor applied to the matrix values
		 */		
		public function get divisor():Number { return _divisor; }

		/**
		 * Bias applied to the matrix values
		 */		
		public function get bias():Number { return _bias; }

		/**
		 * Matrix values
		 */		
		public function get matrix():Vector.<Number> { return _matrix; }

		/**
		 * Default color for pixels outside the image
		 */		
		public function get color():RGBAColor { return _color; }

		/**
		 * Clamp mode
		 */		
		public function get clamp():uint { return _clamp; }

		/**
		 * Preserve the alpha
		 */		
		public function get preserveAlpha():uint { return _preserveAlpha; }
		
		/**
		 * 滤镜类型
		 */		
		public function get type():uint { return FilterType.CONVOLUTION_FILTER; }

	}
}