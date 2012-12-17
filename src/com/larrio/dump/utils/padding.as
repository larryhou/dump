package com.larrio.dump.utils
{
	
	/**
	 * 字符串填充工具
	 * @author larryhou
	 * @createTime Dec 17, 2012 1:41:53 PM
	 */
	public function padding(str:String, length:int, char:String = " ", appendAtRight:Boolean = true):String
	{
		if (appendAtRight)
		{
			while(str.length < length) str += char;
		}
		else
		{
			while(str.length < length) str = char + str;
		}
		
		return str;
	}
}