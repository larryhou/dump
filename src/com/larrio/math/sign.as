package com.larrio.math
{
	
	/**
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:34:31 PM
	 * 
	 * 把无符号整形转换成有符号整形
	 * @param value	无符号整形
	 * @param size	整形最大占用位数，默认4字节32位
	 * @return 有符号整形
	 */		
	public function sign(value:uint, size:uint = 32):int
	{
		size = Math.min(32, Math.max(1, size)) - 1;
		
		var mask:uint = 1, offset:uint = 0;		
		while(offset++ < size) mask = mask << 1 | 1;
		
		var flag:uint = 1 << size;
		if ((value & flag) > 0) value |= ~mask;		
		
		return int(value);
	}
}