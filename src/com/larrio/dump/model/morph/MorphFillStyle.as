package com.larrio.dump.model.morph
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.MatrixRecord;
	import com.larrio.dump.model.colors.RGBAColor;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 1:11:48 PM
	 */
	public class MorphFillStyle implements ICodec
	{
		private var _type:uint;
		
		private var _startColor:RGBAColor;
		private var _endColor:RGBAColor;
		
		private var _startGradientMatrix:MatrixRecord;
		private var _endGradientMatrix:MatrixRecord;
		private var _gradient:MorphGradident;
		
		private var _bitmapId:uint;
		private var _startBitmapMatrix:MatrixRecord;
		private var _endBitmapMatrix:MatrixRecord;
		
		/**
		 * 构造函数
		 * create a [MorphFillStyle] object
		 */
		public function MorphFillStyle()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_type = decoder.readUI8();
			
			switch(_type)
			{
				case 0x00:
				{
					_startColor = new RGBAColor();
					_startColor.decode(decoder);
					
					_endColor = new RGBAColor();
					_endColor.decode(decoder);
					break;
				}
					
				case 0x10:
				case 0x12:
				{
					_startGradientMatrix = new MatrixRecord();
					_startGradientMatrix.decode(decoder);
					
					_endGradientMatrix = new MatrixRecord();
					_endGradientMatrix.decode(decoder);
					
					_gradient = new MorphGradident();
					_gradient.decode(decoder);
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					_bitmapId = decoder.readUI16();
					_startBitmapMatrix = new MatrixRecord();
					_startBitmapMatrix.decode(decoder);
					
					_endBitmapMatrix = new MatrixRecord();
					_endBitmapMatrix.decode(decoder);
					break;
				}
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(_type);
			
			switch(_type)
			{
				case 0x00:
				{
					_startColor.encode(encoder);
					_endColor.encode(encoder);
					break;
				}
					
				case 0x10:
				case 0x12:
				{
					_startGradientMatrix.encode(encoder);
					_endGradientMatrix.encode(encoder);
					_gradient.encode(encoder);
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					encoder.writeUI16(_bitmapId);
					_startBitmapMatrix.encode(encoder);
					_endBitmapMatrix.encode(encoder);
					break;
				}
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<MorphFillStyle/>");
			result.@type = _type;
			
			switch(_type)
			{
				case 0x00:
				{
					result.appendChild(new XML(_startColor.toString()));
					result.appendChild(new XML(_endColor.toString()));
					break;
				}
					
				case 0x10:
				case 0x12:
				{
					result.appendChild(new XML(_startGradientMatrix.toString()));
					result.appendChild(new XML(_endGradientMatrix.toString()));
					result.appendChild(new XML(_gradient.toString()));
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					result.@bitmapId = _bitmapId;
					result.appendChild(new XML(_startBitmapMatrix.toString()));
					result.appendChild(new XML(_endGradientMatrix.toString()));
					break;
				}
			}
			
			return result.toXMLString();	
		}

		/**
		 * Type of fill style
		 * 0x00 = solid fill
		 * 0x10 = linear gradient fill 
		 * 0x12 = radial gradient fill 
		 * 0x40 = repeating bitmap 
		 * 0x41 = clipped bitmap fill 
		 * 0x42 = non-smoothed repeating bitmap
		 * 0x43 = non-smoothed clipped bitmap
		 */		
		public function get type():uint { return _type; }

		/**
		 * Solid fill color with opacity information for start shape.
		 */		
		public function get startColor():RGBAColor { return _startColor; }

		/**
		 * Solid fill color with opacity information for end shape.
		 */		
		public function get endColor():RGBAColor { return _endColor; }

		/**
		 * Matrix for gradient fill for start shape.
		 */		
		public function get startGradientMatrix():MatrixRecord { return _startGradientMatrix; }

		/**
		 * Matrix for gradient fill for end shape.
		 */		
		public function get endGradientMatrix():MatrixRecord { return _endGradientMatrix; }

		/**
		 * Gradient fill.
		 */		
		public function get gradient():MorphGradident { return _gradient; }

		/**
		 * ID of bitmap character for fill.
		 */		
		public function get bitmapId():uint { return _bitmapId; }

		/**
		 * Matrix for bitmap fill for start shape.
		 */		
		public function get startBitmapMatrix():MatrixRecord { return _startBitmapMatrix; }

		/**
		 * Matrix for bitmap fill for end shape.
		 */		
		public function get endBitmapMatrix():MatrixRecord { return _endBitmapMatrix; }

	}
}