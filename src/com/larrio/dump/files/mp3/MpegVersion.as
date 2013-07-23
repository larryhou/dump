package com.larrio.dump.files.mp3
{
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 1:48:04 PM
	 */
	public class MpegVersion
	{
		/**
		 * MPEG1 
		 */		
		public static const MPEG1:uint = 3;
		
		/**
		 * MPEG2.x 
		 */		
		public static const MPEG2:uint = 2;
		
		/**
		 * MPEG2.5 
		 */		
		public static const MPEG2_5:uint = 0;
		
		/**
		 * 版本号转换 
		 */		
		public static function getVersion(value:uint):String
		{
			switch (value)
			{
				case 0: return "MPEG2.5";
				case 2: return "MPEG2";
				case 3: return "MPEG1";
			}
			
			return "unknown";
		}

		
	}
}