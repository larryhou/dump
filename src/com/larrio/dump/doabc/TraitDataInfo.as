package com.larrio.dump.doabc
{
	
	/**
	 * 特性数据信息
	 * @author larryhou
	 * @createTime Dec 20, 2012 11:51:30 AM
	 */
	public class TraitDataInfo
	{
		/**
		 * slot and disp 
		 */	
		public var id:uint;
		
		/**
		 * 指向multinames常量数组的索引 
		 */	
		public var type:uint;
		
		public var index:uint;
		public var kind:uint;
		
		/**
		 * 指向classes数组的索引 
		 */	
		public var classi:uint;
		
		/**
		 * 指向methods常量数组的索引 
		 */	
		public var method:uint;
	}
}