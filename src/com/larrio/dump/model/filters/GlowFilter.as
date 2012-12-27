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
	 * @createTime Dec 25, 2012 11:04:56 PM
	 */
	public class GlowFilter implements IFilter
	{
		private var _color:RGBAColor;
		
		private var _blurX:uint;
		private var _blurY:uint;
		
		private var _strength:uint;
		private var _inner:uint;
		private var _knockOut:uint;
		private var _compositeSource:uint;
		private var _passes:uint;
		
		/**
		 * 构造函数
		 * create a [GlowFilter] object
		 */
		public function GlowFilter()
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
			
			_strength = decoder.readUI16();
			
			_inner = decoder.readUB(1);
			_knockOut = decoder.readUB(1);
			
			_compositeSource = decoder.readUB(1);
			assertTrue(_compositeSource == 1);
			
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
			var result:XML = new XML("<GlowFilter/>");
			result.@blurX = fixed(_blurX, 16, 16);
			result.@blurY = fixed(_blurY, 16, 16);
			result.@strength = fixed(_strength, 8, 8);
			result.@inner = Boolean(_inner);
			result.@knockOut = Boolean(_knockOut);
			result.@passes = _passes;
			
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
		 * glow color
		 */		
		public function get color():RGBAColor { return _color; }

		/**
		 * 滤镜类型
		 */		
		public function get type():uint { return FilterType.GLOW_FILTER; }
	}
}