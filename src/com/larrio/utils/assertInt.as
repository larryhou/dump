package com.larrio.utils
{
	
	/**
	 * @author larryhou
	 * @createTime Dec 15, 2012 5:18:01 PM
	 * 
	 * 断定int类型上下限
	 * @param value	待断定数值
	 * @param size	二进制存储占用比特位数量
	 */		
	public function assertInt(value:int, size:uint):void
	{
		const MAX_VALUE:uint = 1 << (size - 1);
		
		assertTrue(value >= -MAX_VALUE, value + "超出类型下限：" + (-MAX_VALUE));
		assertTrue(value <= MAX_VALUE - 1, value + "超出类型上限！" + (MAX_VALUE - 1));
	}
}