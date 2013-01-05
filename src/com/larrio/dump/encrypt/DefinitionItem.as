package com.larrio.dump.encrypt
{
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 5, 2013 12:09:49 PM
	 */
	public class DefinitionItem
	{
		/**
		 * 包路径命名空间
		 */		
		public var ns:String;
		
		/**
		 * 定义名 
		 */		
		public var name:String;
		
		/**
		 * 是否为接口
		 */		
		public var protocol:Boolean;
		
		/**
		 * 构造函数
		 * create a [DefinitionItem] object
		 */
		public function DefinitionItem(ns:String = "", name:String = "")
		{
			this.ns = ns;
			this.name = name;
		}
	}
}