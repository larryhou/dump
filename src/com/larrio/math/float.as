package com.larrio.math
{
	import flash.utils.describeType;

	/**
	 * 二进制转浮点数
	 * @author larryhou
	 * @createTime Dec 25, 2012 1:44:01 PM
	 * 
	 * @param value	无符号整形
	 * @param size	存储占用比特位数量
	 * @param high	指数存储占用比特位数量
	 * @param bias	指数偏移，如果保持默认则取值为：(1 << (high - 1)) - 1
	 * @return 浮点数
	 */	
	public function float(value:uint, size:uint, hight:uint, bias:uint = 0):Number
	{
		if (!value) return 0;
		
		var low:uint = size - hight - 1;
		
		var sign:uint = (1 << (size - 1)) & value;
		value = (value << 1) >>> 1;
		
		var mantissa:uint = value & ((1 << low) - 1);
		var exponent:int = value >> low & ((1 << hight) - 1);
		
		if (!bias) bias = (1 << (hight - 1)) - 1;
		exponent -= bias;
		
		var integer:int, decimal:Number;
		
		if (exponent >= 0)
		{
			var shift:uint = low - exponent;
			decimal = (mantissa & ((1 << shift) - 1)) / (1 << shift);
			
			mantissa >>>= shift;
			integer = mantissa | 1 << exponent;
		}
		else
		{
			mantissa |= 1 << low;
			mantissa >>>= -exponent;
			
			decimal = mantissa / (1 << low);
		}
		
		return (sign? -1 : 1) * (integer + decimal);
	}
}