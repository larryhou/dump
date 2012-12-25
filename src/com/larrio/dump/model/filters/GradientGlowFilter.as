package com.larrio.dump.model.filters
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.RGBAColor;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 11:26:41 PM
	 */
	public class GradientGlowFilter implements ICodec
	{
		protected var _colors:Vector.<RGBAColor>;
		protected var _ratios:Vector.<uint>;
		
		protected var _blurX:uint;
		protected var _blurY:uint;
		
		protected var _strength:uint;
		protected var _innerGlow:uint;
		protected var _knockOut:uint;
		protected var _compositeSource:uint;
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
			
			_strength = decoder.readUI16();
			
			_innerGlow = decoder.readUB(1);
			_knockOut = decoder.readUB(1);
			
			_compositeSource = decoder.readUB(1);
			assertTrue(_compositeSource == 1);
			
			_passes = decoder.readUB(5);

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
			
			encoder.writeUI16(_strength);
			
			encoder.writeUB(_innerGlow, 1);
			encoder.writeUB(_knockOut, 1);
			
			encoder.writeUB(_compositeSource, 1);
			encoder.writeUB(_passes, 5);
			encoder.flush();
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
		public function get innerGlow():uint { return _innerGlow; }
		
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


	}
}