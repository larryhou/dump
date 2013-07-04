package com.larrio.dump.model.sound
{
	
	/**
	 * 音频码率
	 * @author larryhou
	 * @createTime Jul 3, 2013 5:30:37 PM
	 */
	public class SoundRateType
	{
		/**
		 * 5.5KHz 
		 */		
		public static const HZ_5_5K:uint = 0;
		
		/**
		 * 11KHz 
		 */		
		public static const HZ_11K:uint = 1;
		
		/**
		 * 22KHz 
		 */		
		public static const HZ_22K:uint = 2;
		
		/**
		 * 44KHz 
		 */		
		public static const HZ_44K:uint = 3;
		
		/**
		 * 获取音频采样频率字符串表示
		 */		
		public static function getRate(value:uint):String
		{
			switch(value)
			{
				case 0:return "5.5kHz";
				case 1:return "11kHz";
				case 2:return "22kHz";
				case 3:return "44kHz";
			}
			
			return "unknown";
		}
	}
}