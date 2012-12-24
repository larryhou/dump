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
		private var _offset:Boolean;
		private var _nbits:uint;
		
		private var _multiplier:Boolean;
		
		private var _redOffset:uint;
		private var _greenOffset:uint;
		private var _blueOffset:uint;
		
		private var _redMultiplier:uint;
		private var _greenMultiplier:uint;
		private var _blueMultiplier:uint;
		
		/**
		 * 构造函数
		 * create a [ColorTransformRecord] object
		 */
		public function ColorTransformRecord()
		{
			
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
			
			if (_offset)
			{
				_redOffset = decoder.readUB(_nbits);
				_greenOffset = decoder.readUB(_nbits);
				_blueOffset = decoder.readUB(_nbits);
			}
			
			if (_multiplier)
			{
				_redMultiplier = decoder.readUB(_nbits);
				_greenMultiplier = decoder.readUB(_nbits);
				_blueMultiplier = decoder.readUB(_nbits);
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
			
			if (_offset)
			{
				encoder.writeUB(_redOffset, _nbits);
				encoder.writeUB(_greenOffset, _nbits);
				encoder.writeUB(_blueOffset, _nbits);
			}
			
			if (_multiplier)
			{
				encoder.writeUB(_redMultiplier, _nbits);
				encoder.writeUB(_greenMultiplier, _nbits);
				encoder.writeUB(_blueMultiplier, _nbits);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ColorTransform/>");
			result.@redOffset = _redOffset;
			result.@greenOffset = _greenOffset;
			result.@blueOffset = _blueOffset;
			
			result.@redMultiplier = _redMultiplier;
			result.@greenMultiplier = _greenMultiplier;
			result.@blueMultiplier = _blueMultiplier;
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

	}
}