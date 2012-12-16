package com.larrio.dump.doabc
{
	
	/**
	 * 函数标记类型
	 * @author larryhou
	 * @createTime Dec 16, 2012 6:29:25 PM
	 */
	public class MethodFlagType
	{
		/**
		 * 函数是否有可选传参 
		 * Must be set if this method has optional parameters and the options field is present in this method_info structure.
		 */		
		public static const HAS_OPTIONAL        :uint = 0x8;  // 8
		
		/**
		 * 传参是否有名字 
		 * Must be set when the param_names field is present in this method_info structure.
		 */		
		public static const HAS_PARAM_NAMES     :uint = 0x80; // 128
		
		/**
		 * Must be set if this method uses the newactivation opcode. 
		 */		
		public static const NEED_ACTIVATION     :uint = 0x2;  // 2
		
		/**
		 * arguments变量是否创建 
		 * Suggests to the run-time that an “arguments” object (as specified by the ActionScript 3.0 Language Reference) be created. 
		 * Must not be used together with NEED_REST. 
		 */		
		public static const NEED_ARGUMENTS      :uint = 0x1;  // 1
		
		/**
		 * 是否有长度传参数组 
		 * This flag creates an ActionScript 3.0 rest arguments array. 
		 * Must not be used with NEED_ARGUMENTS.
		 */		
		public static const NEED_REST           :uint = 0x4;  // 4
		
		/**
		 * Must be set if this method uses the dxns or dxnslate opcodes. 
		 */		
		public static const SET_DXNS            :uint = 0x40; // 64
	}
}