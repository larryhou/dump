package com.larrio.math
{
	
	/**
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:34:31 PM
	 * 
	 * 把无符号整形转换成有符号整形
	 * @param value		无符号整形
	 * @param length	整形最大占用位数，默认4字节32位
	 * @return 有符号整形
	 */		
	private function sign(value:uint, length:uint = 32):int
	{
		length = Math.min(32, Math.max(1, length)) - 1;
		
		var mask:uint = 1, offset:uint = 0;		
		while(offset++ < length) mask = mask << 1 | 1;
		
		var flag:uint = 1 << length;
		if ((value & flag) > 0) value |= ~mask;		
		
		return int(value);
	}
}