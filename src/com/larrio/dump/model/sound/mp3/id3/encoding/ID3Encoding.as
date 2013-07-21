package com.larrio.dump.model.sound.mp3.id3.encoding
{
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 12:04:11 AM
	 */
	public class ID3Encoding
	{
		public static const ISO_8859_1:uint = 0x00;
		
		public static const UNICODE:uint = 0x01;
		
		public static const UNICODE_BIG_ENDIAN:uint = 0x02;
		
		public static const UTF_8:uint = 0x03;
		
		public static function type2charset(encoding:uint):String
		{
			switch (encoding)
			{
				case UTF_8: return "utf-8";
				case UNICODE: return "unicode";
				case UNICODE_BIG_ENDIAN: return "unicodeFFFE";
			}
			
			return "iso-8859-1";
		}
		
	}
}