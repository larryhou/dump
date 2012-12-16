package com.larrio.utils
{
	
	/**
	 * @author larryhou
	 * @createTime Dec 15, 2012 4:53:08 PM
	 * 
	 * 布尔值断句
	 * @param value	布尔值
	 * @param msg	报错信息，如果value为false，则msg会以错误形式抛出异常
	 */		
	public function assertTrue(value:Boolean, msg:String = ""):void
	{
		if (!value)
		{
			msg ||= "OOPS...";
			throw new ArgumentError(msg);
		}
	}

}