package com.larrio.dump.interfaces
{
	import com.larrio.dump.doabc.TraitInfo;
	
	/**
	 * 特征对象容器
	 * @author larryhou
	 * @createTime Jul 23, 2013 6:30:53 PM
	 */
	public interface IScript
	{
		/**
		 * 从脚本容器获取成员特征 
		 * @param id	特征ID
		 */		
		function getTrait(id:uint):TraitInfo;
		
		/**
		 * 对象所属
		 */		
		function get belong():IScript;
		function set belong(value:IScript):void
	}
}