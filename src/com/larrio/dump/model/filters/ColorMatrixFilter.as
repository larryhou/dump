package com.larrio.dump.model.filters
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 10:33:04 PM
	 */
	public class ColorMatrixFilter implements ICodec
	{
		private var _matrix:Vector.<Number>;
		
		/**
		 * 构造函数
		 * create a [ColorMatrixFilter] object
		 */
		public function ColorMatrixFilter()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_matrix = new Vector.<Number>(20, true);
			for (var i:int = 0; i < _matrix.length; i++)
			{
				_matrix[i] = decoder.readFloat();
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			for (var i:int = 0; i < _matrix.length; i++)
			{
				encoder.writeFloat(_matrix[i]);
			}
		}

		/**
		 * Color matrix values
		 */		
		public function get matrix():Vector.<Number> { return _matrix; }

	}
}