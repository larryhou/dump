package com.larrio.dump.model.sound.mp3.id3.headers
{
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 21, 2013 2:48:30 PM
	 */
	public class ID3Footer extends ID3Header
	{
		/**
		 * 构造函数
		 * create a [ID3Footer] object
		 */
		public function ID3Footer()
		{
			
		}
		
		public static function verify(bytes:ByteArray):Boolean
		{
			if (bytes.bytesAvailable < NUM_IDENTIFIER_BYTES) return false;
			
			var str:String = bytes.readMultiByte(NUM_IDENTIFIER_BYTES, "utf-8");
			bytes.position -= NUM_IDENTIFIER_BYTES;
			return str == "3DI";
		}
	}
}