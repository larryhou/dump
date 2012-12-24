package com.larrio.math
{
	
	/**
	 * 浮点型转二进制
	 * @author larryhou
	 * @createTime Dec 24, 2012 9:54:25 AM
	 * 
	 * @param value	浮点型
	 * @param high	整数部分占用比特位数
	 * @param low	小数部分占用比特位数
	 * 二进制表示，最大32位
	 */		
	public function unfixed(value:Number, high:uint, low:uint):uint
	{
		var integer:int = value >> 0;
		var decimal:Number = Math.abs(value - integer);
		
		return (unsign(integer, high) << low) | (decimal * (1 << low) >> 0);
	}
}