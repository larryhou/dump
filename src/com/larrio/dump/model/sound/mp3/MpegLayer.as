package com.larrio.dump.model.sound.mp3
{
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 1:51:47 PM
	 */
	public class MpegLayer
	{
		/**
		 * Layer 1 
		 */		
		public static const LAYER1:uint = 3;
		
		/**
		 * Layer 2 
		 */		
		public static const LAYER2:uint = 2;
		
		/**
		 * Layer 3 
		 */		
		public static const LAYER3:uint = 1;
		
		/**
		 * 图层转换 
		 */		
		public static function getLayer(value:uint):uint
		{
			switch (value)
			{
				case 1: return 3;
				case 2: return 2;
				case 3: return 1;
			}
			
			return 0;
		}
	}
}