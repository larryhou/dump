package com.larrio.dump.encrypt
{
	import com.larrio.dump.tags.DoABCTag;
	
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
		 * DoABCTag引用
		 */		
		public var tag:DoABCTag;
		
		/**
		 * 构造函数
		 * create a [EncryptItem] object
		 */
		public function EncryptItem(tag:DoABCTag)
		{
			this.tag = tag;
			this.strings = tag.abc.constants.strings;
			
			this.classes = new Vector.<uint>;
			this.packages = new Vector.<uint>;
		}
	}
}