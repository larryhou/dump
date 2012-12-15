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
		assertTrue(value >= -(1 << (size - 1)), value + "超出类型下限！");
		assertTrue(value <= (1 << (size - 1) - 1), value + "超出类型上限！");
	}
}