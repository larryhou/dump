package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.math.fixed;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 12:36:56 PM
	 */
	public class FocalGradient extends Gradient
	{
		private var _focalPoint:uint;
		
		/**
		 * 构造函数
		 * create a [FocalGradient] object
		 */
		public function FocalGradient(shape:uint)
		{
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			_focalPoint = decoder.readUI16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			super.encode(encoder);
			
			encoder.writeUI16(_focalPoint);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML(super.toString().replace(/Gradient/g, "FocalGradient"));
			result.@focalPoint = fixed(_focalPoint, 8, 8);
			return result.toXMLString();	
		}

		/**
		 * Focal point location：FIXED8.8
		 */		
		public function get focalPoint():uint { return _focalPoint; }
		
	}
}