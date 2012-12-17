package com.larrio.dump.doabc
{
	
	/**
	 * 实例类型常量
	 * @author larryhou
	 * @createTime Dec 17, 2012 9:39:50 AM
	 */
	public class InstanceType
	{
		/**
		 * The class is final: it cannot be a base class for any other class. 
		 */		
		public static const CLASS_FINAL         :uint = 0x2;  // 2
		
		/**
		 * The class is an interface. 
		 */		
		public static const CLASS_INTERFACE     :uint = 0x4;  // 4
		
		/**
		 * The class uses its protected namespace and the protectedNs field is present in the interface_info structure. 
		 */		
		public static const CLASS_PROTECTED_NS  :uint = 0x8;  // 8
		
		/**
		 * The class is sealed: properties can not be dynamically added to instances of the class. 
		 */		
		public static const CLASS_SEALED        :uint = 0x1;  // 1	
	}
}