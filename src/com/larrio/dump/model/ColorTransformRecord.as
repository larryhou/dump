package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.geom.ColorTransform;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 12:28:09 PM
	 */
	public class ColorTransformRecord implements ICodec
	{
		private var _alpha:Boolean;
		private var _offset:uint;
		private var _nbits:uint;
		
		private var _multiplier:uint;
		
		private var _redOffset:int;
		private var _greenOffset:int;
		private var _blueOffset:int;
		private var _alphaOffset:int;
		
		private var _redMultiplier:int;
		private var _greenMultiplier:int;
		private var _blueMultiplier:int;
		private var _alphaMultiplier:int;
		
		/**
		 * 构造函数
		 * create a [ColorTransformRecord] object
		 */
		public function ColorTransformRecord(alpha:Boolean = false)
		{
			_alpha = alpha;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			decoder.byteAlign();
			
			_offset = decoder.readUB(1);
			_multiplier = decoder.readUB(1);
			
			_nbits = decoder.readUB(4);
			
			if (_multiplier)
			{
				_redMultiplier = decoder.readSB(_nbits);
				_greenMultiplier = decoder.readSB(_nbits);
				_blueMultiplier = decoder.readSB(_nbits);
				
				if (_alpha)
				{
					_alphaMultiplier = decoder.readSB(_nbits);
				}
			}
			
			if (_offset)
			{
				_redOffset = decoder.readSB(_nbits);
				_greenOffset = decoder.readSB(_nbits);
				_blueOffset = decoder.readSB(_nbits);
				
				if (_alpha)
				{
					_alphaOffset = decoder.readSB(_nbits);
				}
			}
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.flush();
			
			encoder.writeUB(_offset, 1);
			encoder.writeUB(_multiplier, 1);
			encoder.writeUB(_nbits, 4);
			
			if (_multiplier)
			{
				encoder.writeSB(_redMultiplier, _nbits);
				encoder.writeSB(_greenMultiplier, _nbits);
				encoder.writeSB(_blueMultiplier, _nbits);
				
				if (_alpha)
				{
					encoder.writeSB(_alphaMultiplier, _nbits);
				}
			}
			
			if (_offset)
			{
				encoder.writeSB(_redOffset, _nbits);
				encoder.writeSB(_greenOffset, _nbits);
				encoder.writeSB(_blueOffset, _nbits);
				
				if (_alpha)
				{
					encoder.writeSB(_alphaOffset, _nbits);
				}
			}
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ColorTransform/>");
			result.@redMultiplier = _redMultiplier / 256;
			result.@greenMultiplier = _greenMultiplier / 256;
			result.@blueMultiplier = _blueMultiplier / 256;
			
			if (_alpha)
			{
				result.@alphaMultiplier = _alphaMultiplier / 256;
			}
			
			result.@redOffset = _redOffset;
			result.@greenOffset = _greenOffset;
			result.@blueOffset = _blueOffset;
			
			if (_alpha)
			{
				result.@alphaOffset = _alphaOffset;
			}

			return result.toXMLString();	
		}

		/**
		 * red offset
		 */		
		public function get redOffset():uint { return _redOffset; }
		public function set redOffset(value:uint):void
		{
			_offset = 1;
			_redOffset = value;
		}

		/**
		 * green offset 
		 */		
		public function get greenOffset():uint { return _greenOffset; }
		public function set greenOffset(value:uint):void
		{
			_offset = 1;
			_greenOffset = value;
		}

		/**
		 * blue offset
		 */		
		public function get blueOffset():uint { return _blueOffset; }
		public function set blueOffset(value:uint):void
		{
			_offset = 1;
			_blueOffset = value;
		}

		/**
		 * red multiplier
		 */		
		public function get redMultiplier():Number { return _redMultiplier / 256; }
		public function set redMultiplier(value:Number):void
		{
			_multiplier = 1;
			_redMultiplier = value * 256 >> 0;
		}

		/**
		 * green multiplier
		 */		
		public function get greenMultiplier():Number { return _greenMultiplier / 256; }
		public function set greenMultiplier(value:Number):void
		{
			_multiplier = 1;
			_greenMultiplier = value * 256 >> 0;
		}

		/**
		 * blue multiplier
		 */		
		public function get blueMultiplier():Number { return _blueMultiplier / 256; }
		public function set blueMultiplier(value:Number):void
		{
			_multiplier = 1;
			_blueMultiplier = value * 256 >> 0;
		}

		/**
		 * alpha offset
		 */		
		public function get alphaOffset():uint { return _alphaOffset; }
		public function set alphaOffset(value:uint):void
		{
			_alpha = true;
			
			_offset = 1;
			_alphaOffset = value;
		}

		/**
		 * alpha multiplier
		 */		
		public function get alphaMultiplier():uint { return _alphaMultiplier; }
		public function set alphaMultiplier(value:uint):void
		{
			_alpha = true;
			
			_multiplier = 1;
			_alphaMultiplier = value;
		}

		/**
		 * 把ColorTransformRecord转换成原生ColorTransform 
		 */		
		public function get transform():ColorTransform 
		{ 
			var result:ColorTransform = new ColorTransform();
			result.redOffset = this.redOffset;
			result.greenOffset = this.greenOffset;
			result.blueOffset = this.blueOffset;
			result.alphaOffset = this.alphaOffset;
			
			result.redMultiplier = this.redMultiplier;
			result.greenMultiplier = this.greenMultiplier;
			result.blueMultiplier = this.blueMultiplier;
			result.alphaMultiplier = this.alphaMultiplier;
			
			return result; 
		}
		
		/**
		 * 把原生ColorTransform转换成ColorTransformRecord 
		 */		
		public function set transform(value:ColorTransform):void
		{
			this.redOffset = value.redOffset;
			this.greenOffset = value.greenOffset;
			this.blueOffset = value.blueOffset;
			this.alphaOffset = value.alphaOffset;
			
			this.redMultiplier = value.redMultiplier;
			this.greenMultiplier = value.greenMultiplier;
			this.blueMultiplier = value.blueMultiplier;
			this.alphaMultiplier = value.alphaMultiplier;
			
			if (_offset || _multiplier)
			{
				if (!_nbits) _nbits = 15;
			}
		}
	}
}