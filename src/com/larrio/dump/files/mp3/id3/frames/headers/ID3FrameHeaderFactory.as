package com.larrio.dump.files.mp3.id3.frames.headers
{
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 22, 2013 2:11:45 AM
	 */
	public class ID3FrameHeaderFactory
	{
		/**
		 * 构造函数
		 * create a [ID3FrameHeaderFactory] object
		 */
		public function ID3FrameHeaderFactory()
		{
			
		}
		
		public static function create(majorVersion:uint):ID3FrameHeader
		{
			switch (majorVersion)
			{
				case 0x04:return new ID3v24FrameHeader();
				case 0x03:return new ID3v23FrameHeader();
				case 0x02:return new ID3v22FrameHeader();
			}
			
			return new ID3v22FrameHeader();
		}
	}
}