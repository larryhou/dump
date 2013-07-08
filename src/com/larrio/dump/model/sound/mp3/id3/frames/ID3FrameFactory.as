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
			var frame:ID3Frame;
			switch (identifier)
			{
				default:frame = new ID3Frame();break;
			}
			
			return frame;
		}
	}
}