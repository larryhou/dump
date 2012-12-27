package com.larrio.dump.model.filters
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.math.fixed;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 10:55:33 PM
	 */
	public class DropShadowFilter implements IFilter
	{
		private var _color:RGBAColor;
		
		private var _blurX:uint;
		private var _blurY:uint;
		private var _angle:uint;
		private var _distance:uint;
		private var _strength:uint;
		
		private var _inner:uint;
		private var _knockOut:uint;
		
		private var _compositeSource:uint;
		private var _passes:uint;
		
		/**
		 * 构造函数
		 * create a [DropShadowFilter] object
		 */
		public function DropShadowFilter()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_color = new RGBAColor();
			_color.decode(decoder);
			
			_blurX = decoder.readUI32();
			_blurY = decoder.readUI32();
			
			_angle = decoder.readUI32();
			_distance = decoder.readUI32();
			_strength = decoder.readUI16();
			
			_inner = decoder.readUB(1);
			_knockOut = decoder.readUB(1);
			
			_compositeSource = decoder.readUB(1);
			_passes = decoder.readUB(5);
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			_color.encode(encoder);
			
			encoder.writeUI32(_blurX);
			encoder.writeUI32(_blurY);
			
			encoder.writeUI32(_angle);
			encoder.writeUI32(_distance);
			encoder.writeUI16(_strength);
			
			encoder.writeUB(_inner, 1);
			encoder.writeUB(_knockOut, 1);
			
			encoder.writeUB(_compositeSource, 1);
			encoder.writeUB(_passes, 5);
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DropShadowFilter/>");
			result.@blurX = fixed(_blurX, 16, 16);
			result.@blurY = fixed(_blurY, 16, 16);
			result.@angle = (180 * fixed(_angle, 16, 16) / Math.PI).toFixed(0);
			result.@distance = fixed(_distance, 16, 16);
			result.@strength = fixed(_strength, 8, 8);
			result.@inner = Boolean(_inner);
			result.@knockOut = Boolean(_knockOut);
			result.@passes = _passes;
			result.appendChild(new XML(_color.toString()));
			
			return result.toXMLString();
		}

		/**
		 * Horizontal blur amount: 16.16 fixed-point
		 */		
		public function get blurX():uint { return _blurX; }

		/**
		 * Vertical blur amount: 16.16 fixed-point
		 */		
		public function get blurY():uint { return _blurY; }

		/**
		 * Radian angle of the drop shadow: 16.16 fixed-point
		 */		
		public function get angle():uint { return _angle; }

		/**
		 * Distance of the drop shadow: 16.16 fixed-point
		 */		
		public function get distance():uint { return _distance; }

		/**
		 * Strength of the drop shadow: 8.8 fixed-point
		 */		
		public function get strength():uint { return _strength; }

		/**
		 * Inner shadow mode
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
		 * 滤镜类型
		 */		
		public function get type():uint { return FilterType.DROP_SHADOW_FILTER; }

	}
}