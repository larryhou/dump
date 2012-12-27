package com.larrio.dump.model.filters
{
	import com.larrio.dump.model.types.FilterType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 11:34:56 PM
	 */
	public class GradientBevelFilter extends GradientGlowFilter
	{
		/**
		 * 构造函数
		 * create a [GradientBevelFilter] object
		 */
		public function GradientBevelFilter()
		{
			
		}
		
		/**
		 * 滤镜类型
		 */		
		override public function get type():uint { return FilterType.GRADIENT_BEVEL_FILTER; }
	}
}