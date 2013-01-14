package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.MatrixRecord;
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.model.colors.RGBColor;
	import com.larrio.dump.tags.TagType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 12:47:25 PM
	 */
	public class FillStyle implements ICodec
	{
		private var _shape:uint;
		
		private var _type:uint;
		private var _color:RGBColor;
		private var _gradientMatrix:MatrixRecord;
		private var _gradient:Gradient;
		private var _bitmapId:uint;
		private var _bitmapMatrix:MatrixRecord;
		
		/**
		 * 构造函数
		 * create a [FillStyle] object
		 */
		public function FillStyle(shape:uint)
		{
			_shape = shape;
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
					switch(_shape)
					{
						case TagType.DEFINE_SHAPE:
						case TagType.DEFINE_SHAPE2:
						{
							_color = new RGBColor();
							break;
						}
							
						default:
						{
							_color = new RGBAColor();
							break;
						}
					}
					
					_color.decode(decoder);
					break;
				}
					
				case 0x10:
				case 0x12:
				case 0x13:
				{
					_gradientMatrix = new MatrixRecord();
					_gradientMatrix.decode(decoder);
					
					if (_type == 0x10 || _type == 0x12)
					{
						_gradient = new Gradient(_shape);
					}
					else
					{
						_gradient = new FocalGradient(_shape);
					}
					
					decoder.byteAlign();
					_gradient.decode(decoder);
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					_bitmapId = decoder.readUI16();
					_bitmapMatrix = new MatrixRecord();
					_bitmapMatrix.decode(decoder);
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
					_color.encode(encoder);
					break;
				}
				
				case 0x10:
				case 0x12:
				case 0x13:
				{
					_gradientMatrix.encode(encoder);
					
					encoder.flush();
					_gradient.encode(encoder);
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					encoder.writeUI16(_bitmapId);
					_bitmapMatrix.encode(encoder);
					break;
				}
			}

		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<FillStyle/>");
			result.@type = _type.toString(16);
			
			if (_color)
			{
				result.appendChild(new XML(_color.toString()));
			}
			
			switch(_type)
			{
				case 0x10:
				case 0x12:
				case 0x13:
				{
					result.appendChild(new XML(_gradientMatrix.toString()));
					result.appendChild(new XML(_gradient.toString()));
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					result.@bitmapId = _bitmapId;
					result.appendChild(new XML(_bitmapMatrix.toString()));
					break;
				}
			}

			return result.toXMLString();	
		}

		/**
		 * 0x00 = solid fill
		 * 0x10 = linear gradient fill
		 * 0x12 = radial gradient fill
		 * 0x13 = focal radial gradient fill (SWF 8 file format and later only)
		 * 
		 * 0x40 = repeating bitmap fill 
		 * 0x41 = clipped bitmap fill 
		 * 0x42 = non-smoothed repeating bitmap
		 * 0x43 = non-smoothed clipped bitmap
		 */		
		public function get type():uint { return _type; }

		/**
		 * Solid fill color with opacity information.
		 * RGB (if Shape1 or Shape2)
		 * RGBA (if Shape3 or Shape4);
		 */		
		public function get color():RGBColor { return _color; }

		/**
		 * Matrix for gradient fill.
		 */		
		public function get gradientMatrix():MatrixRecord { return _gradientMatrix; }

		/**
		 * Gradient fill.
		 */		
		public function get gradient():Gradient { return _gradient; }

		/**
		 * ID of bitmap character for fill.
		 */		
		public function get bitmapId():uint { return _bitmapId; }

		/**
		 * Matrix for bitmap fill.
		 */		
		public function get bitmapMatrix():MatrixRecord { return _bitmapMatrix; }

	}
}