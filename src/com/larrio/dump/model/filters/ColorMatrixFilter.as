package com.larrio.dump.model.filters
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.types.FilterType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 10:33:04 PM
	 */
	public class ColorMatrixFilter implements IFilter
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
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ColorMatrixFilter/>");
			
			var item:Array, length:uint = _matrix.length;
			for (var i:int = 0; i < _matrix.length; i++)
			{
				if (!item) item = [];
				item.push(_matrix[i].toFixed(2));
				
				if ((i + 1) % 5 == 0)
				{
					result.appendChild(new XML("<Row>" + item.join("\t") + "</Row>"));
					item = null;
				}
			}
			return result.toXMLString();
		}

		/**
		 * Color matrix values
		 */		
		public function get matrix():Vector.<Number> { return _matrix; }
		
		/**
		 * 滤镜类型
		 */		
		public function get type():uint { return FilterType.COLOR_MATRIX_FILTER; }

	}
}