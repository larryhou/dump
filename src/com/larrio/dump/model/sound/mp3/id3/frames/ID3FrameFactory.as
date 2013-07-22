package com.larrio.dump.model.sound.mp3.id3.frames
{
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 12:36:48 AM
	 */
	public class ID3FrameFactory
	{
				
		/**
		 * 工厂方法创建
		 * @param identifier
		 */
		public static function create(identifier:String):ID3Frame
		{
			if (identifier.match(/^T/))
			{
				return identifier == "TXXX"? new ID3UserTextFrame() : new ID3TextFrame();
			}
			
			
			if (identifier.match(/^W/))
			{
				return identifier == "WXXX"? new ID3UserLinkFrame() : new ID3LinkFrame();
			}
			
			return new ID3Frame();
		}
	}
}