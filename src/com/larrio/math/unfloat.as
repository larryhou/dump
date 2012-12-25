package com.larrio.math
{
	/**
	 * 浮点数转二进制
	 * @author larryhou
	 * @createTime Dec 25, 2012 1:44:01 PM
	 * 
	 * @param value	浮点数
	 * @param size	存储占用比特位数量
	 * @param high	指数存储占用比特位数量
	 * @param bias	指数偏移，如果保持默认则取值为：(1 << (high - 1)) - 1
	 * @return 二进制：最大32位
	 */		
	public function unfloat(value:Number, size:uint, high:uint, bias:uint = 0):uint
	{
		if (!value) return 0;
		
		var low:uint = size - high - 1;
		
		var sign:uint = value >= 0? 0 : 1;
		value = Math.abs(value);
		
		var integer:uint = value >> 0;
		var decimal:Number = value - integer;
		
		var exponent:uint, mantissa:uint;
		if (bias == 0) bias = (1 << (high - 1)) - 1;
		
		exponent = 0;
		if (value >= 1)
		{
			while (integer > 1)
			{
				exponent++;
				integer >>>= 1;
			}
			
			var shift:uint = low - exponent;
			mantissa = decimal * (1 << shift) + 0.5 >> 0;
			
			integer = (value >> 0) & ((1 << exponent) - 1);
			mantissa |= integer << shift;
		}
		else
		{
			mantissa = decimal * (1 << low) + 0.5 >> 0;
			var mask:uint = 1 << (low - 1);
			
			while(mask && mantissa)
			{
				exponent--;
				if ((mantissa & mask) == 0)
				{
					mask >>>= 1;
					continue;
				}
				
				mantissa &= mask - 1;
				mantissa <<= -exponent;
				break;
			}
		}
		
		return sign << (size - 1) | (exponent + bias) << low | mantissa;
	}
}