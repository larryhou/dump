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
			if (identifier.match(/^T/) && identifier != "TXXX")
			{
				return new ID3TextFrame();
			}
			
			return new ID3Frame();
		}
	}
}