package com.larrio.dump.doabc
{
	
	/**
	 * 命名空间类型
	 * @author larryhou
	 * @createTime Dec 16, 2012 5:12:56 PM
	 */
	public class NSKindType
	{
		/**
		 * explicit namespace 
		 */		
		public static const EXPLICIT_NAMESPACE       :uint = 0x19; // 25
		
		/**
		 * namespace 
		 */		
		public static const NAMESPACE                :uint = 0x8;  // 8
		
		/**
		 * package internal 
		 */		
		public static const PACKAGE_INTERNAL_NS      :uint = 0x17; // 23
		
		/**
		 * package 
		 */		
		public static const PACKAGE_NAMESPACE        :uint = 0x16; // 22
		
		/**
		 * private 
		 */		
		public static const PRIVATE_NS               :uint = 0x5;  // 5
		
		/**
		 * protected 
		 */		
		public static const PROTECTED_NAMESPACE      :uint = 0x18; // 24
		
		/**
		 * static protected 
		 */		
		public static const STATIC_PROTECTED_NS      :uint = 0x1A; // 26
	}
}