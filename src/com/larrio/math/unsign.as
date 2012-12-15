package com.larrio.math
{
	
	/**
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:35:56 PM
	 * 
	 * 把有符号整形转换成无符号整形
	 * @param value		有符号整形
	 * @param length	整形最大占用位数，默认4字节32位
	 * @return 无符号整形
	 */		
	private function unsign(value:int, length:uint = 32):int
	{
		length = Math.min(32, Math.max(1, length)) - 1;
		
		var mask:uint = 1, offset:uint = 0;		
		while(offset++ < length) mask = mask << 1 | 1;
		
		return uint(value) & mask;
	}
}