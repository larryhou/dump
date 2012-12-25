package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 12:28:09 PM
	 */
	public class ColorTransformRecord implements ICodec
	{
		private var _alpha:Boolean;
		private var _offset:Boolean;
		private var _nbits:uint;
		
		private var _multiplier:Boolean;
		
		private var _redOffset:uint;
		private var _greenOffset:uint;
		private var _blueOffset:uint;
		private var _alphaOffset:uint;
		
		private var _redMultiplier:uint;
		private var _greenMultiplier:uint;
		private var _blueMultiplier:uint;
		private var _alphaMultiplier:uint;
		
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
			_offset = Boolean(decoder.readUB(1));
			_multiplier = Boolean(decoder.readUB(1);
			
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
			encoder.writeUB(int(_offset), 1);
			encoder.writeUB(int(_multiplier), 1);
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
			
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ColorTransform/>");
			result.@redMultiplier = _redMultiplier;
			result.@greenMultiplier = _greenMultiplier;
			result.@blueMultiplier = _blueMultiplier;
			
			if (_alpha)
			{
				result.@alphaMultiplier = _alphaMultiplier;
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

		/**
		 * green offset 
		 */		
		public function get greenOffset():uint { return _greenOffset; }

		/**
		 * blue offset
		 */		
		public function get blueOffset():uint { return _blueOffset; }

		/**
		 * red multiplier
		 */		
		public function get redMultiplier():uint { return _redMultiplier; }

		/**
		 * green multiplier
		 */		
		public function get greenMultiplier():uint { return _greenMultiplier; }

		/**
		 * blue multiplier
		 */		
		public function get blueMultiplier():uint { return _blueMultiplier; }

		/**
		 * alpha offset
		 */		
		public function get alphaOffset():uint { return _alphaOffset; }

		/**
		 * alpha multiplier
		 */		
		public function get alphaMultiplier():uint { return _alphaMultiplier; }

	}
}