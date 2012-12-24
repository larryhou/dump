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
		var shift:uint = 32 - low;
		var decimal:Number = ((value << shift) >>> shift) / (1 << low);
		
		var integer:int = sign(value >>> low, high);
		return integer >= 0? (integer + decimal) : (integer - decimal);
	}
}