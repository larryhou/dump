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
		 * 添加特征对象 
		 * @param trait	特征对象
		 */
		function addTrait(trait:TraitInfo):uint;
		
		/**
		 * 移除特征对象 
		 * @param script IScript脚本对象
		 */		
		function removeScript(script:IScript):void;
		
		/**
		 * 添加子脚本 
		 * @param script IScript脚本对象
		 */		
		function addScript(script:IScript):void;
		
		/**
		 * 变量列表
		 */	
		function get slots():Vector.<TraitInfo>;
		
		/**
		 * 方法列表
		 */		
		function get methods():Vector.<TraitInfo>;
		
		/**
		 * 类列表 
		 */		
		function get classes():Vector.<TraitInfo>;
		
		/**
		 * 对象所属
		 */		
		function get belong():IScript;
		function set belong(value:IScript):void
			
		/**
		 * 子脚本对象
		 */	
		function get children():Vector.<IScript>;
	}
}