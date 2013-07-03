package com.larrio.dump.model.sound
{
	
	/**
	 * 声音文件格式
	 * @author larryhou
	 * @createTime Jul 3, 2013 5:18:13 PM
	 */
	public class SoundFormatType
	{
		/**
		 * 未压缩 
		 */		
		public static const UNCOMP_NATIVE_ENDIANT:uint = 0;
		
		/**
		 * ADPCM压缩
		 */		
		public static const ADPCM:uint = 1;
		
		/**
		 * MP3压缩 
		 */		
		public static const MP3:uint = 2;
		
		/**
		 * 未压缩 
		 */		
		public static const UNCOMP_LITTLE_ENDIANT:uint = 3;
		
		/**
		 *  Nellymoser 16 kHz
		 */		
		public static const NELLY_MORSER_16K:uint = 4;
		
		/**
		 * Nellymoser 8 kHz 
		 */		
		public static const NELLY_MORSER_8K:uint = 5;
		
		/**
		 * Nellymorser 
		 */		
		public static const NELLY_MOSER:uint = 6;
		
		/**
		 * Speex 
		 */		
		public static const SPEEX:uint = 11;
		
	}
}