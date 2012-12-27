package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.filters.BevelFilter;
	import com.larrio.dump.model.filters.BlurFilter;
	import com.larrio.dump.model.filters.ColorMatrixFilter;
	import com.larrio.dump.model.filters.ConvolutionFilter;
	import com.larrio.dump.model.filters.DropShadowFilter;
	import com.larrio.dump.model.filters.GlowFilter;
	import com.larrio.dump.model.filters.GradientBevelFilter;
	import com.larrio.dump.model.filters.GradientGlowFilter;
	import com.larrio.dump.model.filters.IFilter;
	import com.larrio.dump.model.types.FilterType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 26, 2012 11:57:44 PM
	 */
	public class FilterList implements ICodec
	{
		private var _filters:Vector.<IFilter>;
		
		/**
		 * 构造函数
		 * create a [FilterList] object
		 */
		public function FilterList()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var type:uint;
			var length:uint, i:int;
			
			length = decoder.readUI8();
			_filters = new  Vector.<IFilter>(length, true);
			
			var filter:IFilter;
			for (i = 0; i < length; i++)
			{
				type = decoder.readUI8();
				switch(type)
				{
					case FilterType.DROP_SHADOW_FILTER:
					{	
						filter = new DropShadowFilter();
						break;
					}
						
					case FilterType.BLUR_FILTER:
					{
						filter = new BlurFilter();
						break;
					}
						
					case FilterType.GLOW_FILTER:
					{
						filter = new GlowFilter();
						break;
					}
						
					case FilterType.BEVEL_FILTER:
					{
						filter = new BevelFilter();
						break;
					}
						
					case FilterType.GRADIENT_GLOW_FILTER:
					{
						filter = new GradientGlowFilter();
						break;
					}
						
					case FilterType.CONVOLUTION_FILTER:
					{
						filter = new ConvolutionFilter();
						break;
					}
						
					case FilterType.COLOR_MATRIX_FILTER:
					{
						filter = new ColorMatrixFilter();
						break;
					}
						
					case FilterType.GRADIENT_BEVEL_FILTER:
					{
						filter = new GradientBevelFilter();
						break;
					}
				}
				
				if (filter)
				{
					filter.decode(decoder);
					
					_filters[i] = filter;
				}
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var type:uint;
			var length:uint, i:int;
			
			length = _filters.length;
			encoder.writeUI8(length);
			
			var filter:IFilter;
			for (i = 0; i < length; i++)
			{
				filter = _filters[i];
				
				encoder.writeUI8(filter.type);
				filter.encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<FilterList/>");
			result.@length = _filters.length;
			
			var length:uint = _filters.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_filters[i] + ""));
			}
			
			return result.toXMLString();	
		}

		/**
		 * 滤镜列表
		 */		
		public function get filters():Vector.<IFilter> { return _filters; }

	}
}