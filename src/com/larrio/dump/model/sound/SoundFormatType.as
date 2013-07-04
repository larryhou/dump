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
		public static const UNCOMP_NATIVE_ENDIAN:uint = 0;
		
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
		public static const UNCOMP_LITTLE_ENDIAN:uint = 3;
		
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
		
		/**
		 * 获取音频格式字符串表示
		 */		
		public static function getFormat(value:uint):String
		{
			switch (value)
			{
				case 0: return "Uncompressed, native-endian";
				case 1: return "ADPCM";
				case 2: return "MP3";
				case 3: return "Uncompressed, little-endian";
				case 4: return "Nellymoser 16 kHz";
				case 5: return "Nellymoser 8 kHz";
				case 6: return "Nellymoser";
				case 11:return "Speex";
			}
			
			return "Unknown";
		}
		
	}
}