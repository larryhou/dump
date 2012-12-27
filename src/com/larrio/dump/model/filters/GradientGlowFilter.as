package com.larrio.dump.model.filters
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.RGBAColor;
	import com.larrio.dump.model.types.FilterType;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.math.fixed;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 11:26:41 PM
	 */
	public class GradientGlowFilter implements IFilter
	{
		protected var _colors:Vector.<RGBAColor>;
		protected var _ratios:Vector.<uint>;
		
		protected var _blurX:uint;
		protected var _blurY:uint;
		
		protected var _angle:uint;
		protected var _distance:uint;
		protected var _strength:uint;
		protected var _inner:uint;
		protected var _knockOut:uint;
		protected var _compositeSource:uint;
		protected var _onTop:uint;
		protected var _passes:uint;
		
		/**
		 * 构造函数
		 * create a [GradientGlowFilter] object
		 */
		public function GradientGlowFilter()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var length:uint, i:int;
			length = decoder.readUI8();
			_colors = new Vector.<RGBAColor>(length, true);
			for (i = 0; i < length; i++)
			{
				_colors[i] = new RGBAColor();
				_colors[i].decode(decoder);
			}
			
			_ratios = new Vector.<uint>(length, true);
			for (i = 0; i < length; i++)
			{
				_ratios[i] = decoder.readUI8();
			}

			_blurX = decoder.readUI32();
			_blurY = decoder.readUI32();
			
			_angle = decoder.readUI32();
			_distance = decoder.readUI32();
			_strength = decoder.readUI16();
			
			_inner = decoder.readUB(1);
			_knockOut = decoder.readUB(1);
			
			_compositeSource = decoder.readUB(1);
			assertTrue(_compositeSource == 1);
			
			_onTop = decoder.readUB(1);
			_passes = decoder.readUB(4);

			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:uint, i:int;
			
			length = _colors.length;
			encoder.writeUI8(length);
			
			for (i = 0; i < length; i++)
			{
				_colors[i].encode(encoder);
			}
			
			for (i = 0; i < length; i++)
			{
				encoder.writeUI8(_ratios[i]);
			}
			
			encoder.writeUI32(_blurX);
			encoder.writeUI32(_blurY);
			
			encoder.writeUI32(_angle);
			encoder.writeUI32(_distance);
			encoder.writeUI16(_strength);
			
			encoder.writeUB(_inner, 1);
			encoder.writeUB(_knockOut, 1);
			
			encoder.writeUB(_compositeSource, 1);
			encoder.writeUB(_onTop, 1);
			encoder.writeUB(_passes, 4);
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<GradientGlowFilter/>");
			result.@blurX = fixed(_blurX, 16, 16);
			result.@blurY = fixed(_blurY, 16, 16);
			result.@angle = (180 * fixed(_angle, 16, 16) / Math.PI).toFixed(0);
			result.@distance = fixed(_distance, 16, 16);
			result.@strength = fixed(_strength, 8, 8);
			result.@inner = Boolean(_inner);
			result.@knockOut = Boolean(_knockOut);
			result.@onTop = Boolean(_onTop);
			result.@passes = _passes;
			
			var item:XML;
			var length:uint = _colors.length;
			for (var i:int = 0; i < length; i++)
			{
				item = new XML("<Color/>");
				item.@ratio = _ratios[i] / 256;
				item.appendChild(new XML(_colors[i].toString()));
				result.appendChild(item);
			}

			return result.toXMLString();
		}
		
		/**
		 * Horizontal blur amount
		 */		
		public function get blurX():uint { return _blurX; }
		
		/**
		 * Vertical blur amount
		 */		
		public function get blurY():uint { return _blurY; }
		
		/**
		 * Strength of the glow
		 */		
		public function get strength():uint { return _strength; }
		
		/**
		 * Inner glow mode
		 */		
		public function get inner():uint { return _inner; }
		
		/**
		 * Knockout mode
		 */		
		public function get knockOut():uint { return _knockOut; }
		
		/**
		 * Composite source Always 1
		 */		
		public function get compositeSource():uint { return _compositeSource; }
		
		/**
		 * Number of blur passes
		 */		
		public function get passes():uint { return _passes; }

		/**
		 * Gradient colors
		 */		
		public function get colors():Vector.<RGBAColor> { return _colors; }

		/**
		 * Gradient ratios
		 */		
		public function get ratios():Vector.<uint> { return _ratios; }

		/**
		 * 滤镜类型
		 */		
		public function get type():uint { return FilterType.GRADIENT_GLOW_FILTER; }

		/**
		 * Radian angle of the gradient glow
		 */		
		public function get angle():uint { return _angle; }

		/**
		 * Distance of the gradient glow
		 */		
		public function get distance():uint { return _distance; }

		/**
		 * OnTop mode
		 */		
		public function get onTop():uint { return _onTop; }

		
	}
}