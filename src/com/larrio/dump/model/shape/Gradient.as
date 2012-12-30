package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 10:37:27 PM
	 */
	public class Gradient implements ICodec
	{
		protected var _shape:uint;
		protected var _spreadMode:uint;
		protected var _interpolationMode:uint;
		protected var _gradients:Vector.<GradRecord>;
		
		/**
		 * 构造函数
		 * create a [Gradient] object
		 */
		public function Gradient(shape:uint)
		{
			_shape = shape;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_spreadMode = decoder.readUB(2);
			_interpolationMode = decoder.readUB(2);
			
			var length:uint, i:int;
			length = decoder.readUB(4);
			
			_gradients = new Vector.<GradRecord>(length, true);
			for (i = 0; i < length; i++)
			{
				_gradients[i] = new GradRecord(_shape);
				_gradients[i].decode(decoder);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_spreadMode, 2);
			encoder.writeUB(_interpolationMode, 2);
			
			var length:int, i:int;
			length = _gradients.length;
			encoder.writeUB(length, 4);
			for (i = 0; i < length; i++)
			{
				_gradients[i].encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<Gradient/>");
			result.@spreadMode = _spreadMode;
			result.@interpolationMode = _interpolationMode;
			
			var length:int = _gradients.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_gradients[i].toString()));
			}
			
			return result.toXMLString();
		}

		/**
		 * 0 = Pad mode
		 * 1 = Reflect mode
		 * 2 = Repeat mode 
		 * 3 = Reserved
		 */		
		public function get spreadMode():uint { return _spreadMode; }

		/**
		 * 0 = Normal RGB mode interpolation
		 * 1 = Linear RGB mode interpolation
		 * 2 and 3 = Reserved
		 */		
		public function get interpolationMode():uint { return _interpolationMode; }

		/**
		 * Gradient records
		 */		
		public function get gradients():Vector.<GradRecord> { return _gradients; }
	}
}