package com.larrio.math
{
	
	/**
	 * 比特位转换浮点数
	 * @author larryhou
	 * @createTime Dec 24, 2012 2:03:27 AM
	 * 
	 * @param value	浮点型
	 * @param high	整数部分占用比特位数
	 * @param low	小数部分占用比特位数
	 * 浮点数表示
	 */
	public function fixed(value:uint, high:uint, low:uint):Number
	{
		return sign(value, high + low) / (1 << low);
	}
}