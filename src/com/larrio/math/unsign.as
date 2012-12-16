package com.larrio.math
{
	
	/**
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:35:56 PM
	 * 
	 * 把有符号整形转换成无符号整形
	 * @param value	有符号整形
	 * @param size	整形最大占用位数，默认4字节32位
	 * @return 无符号整形
	 */		
	public function unsign(value:int, size:uint = 32):uint
	{
		size = Math.min(32, Math.max(1, size));
		
		var shift:uint = 32 - size;
		return (uint(value) << shift) >>> shift;
	}
}