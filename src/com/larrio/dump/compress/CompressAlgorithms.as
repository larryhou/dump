package com.larrio.dump.compress
{
	
	/**
	 * 压缩类型
	 * @author larryhou
	 * @createTime Aug 22, 2013 12:42:53 PM
	 */
	public class CompressAlgorithms
	{
		/**
		 * 不压缩 
		 */		
		public static const NONE:String = "FWS";
		
		/**
		 * ZLIB算法压缩 
		 */		
		public static const ZLIB:String = "CWS";
		
		/**
		 * LZMA 算法压缩
		 */		
		public static const LZMA:String = "ZWS";
	}
}