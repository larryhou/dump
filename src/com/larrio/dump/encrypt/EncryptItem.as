package com.larrio.dump.encrypt
{
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 22, 2012 8:51:50 PM
	 */
	public class EncryptItem
	{
		/**
		 * 包名字符串索引 
		 */		
		public var packages:Vector.<uint>;
		
		/**
		 * 类名字符串索引 
		 */		
		public var classes:Vector.<uint>;
		
		/**
		 * 字符串常量池
		 */		
		public var strings:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [EncryptItem] object
		 */
		public function EncryptItem(strings:Vector.<String>)
		{
			this.strings = strings;
			
			this.classes = new Vector.<uint>;
			this.packages = new Vector.<uint>;
		}
	}
}