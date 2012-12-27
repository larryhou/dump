package com.larrio.dump.model.filters
{
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 滤镜接口
	 * @author larryhou
	 * @createTime Dec 27, 2012 12:25:56 PM
	 */
	public interface IFilter extends ICodec
	{
		/**
		 * 滤镜类型
		 */		
		function get type():uint;
	}
}