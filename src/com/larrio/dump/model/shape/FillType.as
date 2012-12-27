package com.larrio.dump.model.shape
{
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 10:28:32 PM
	 */
	public class FillType
	{
		public static const SOLID_FILL                   :uint = 0x00;
		
		public static const LINEAR_GRADIENT_FILL         :uint = 0x10;
		public static const RADIAL_GRADIENT_FILL         :uint = 0x12;
		public static const FOCAL_RADIAL_GRADIENT_FILL   :uint = 0x13;
		
		public static const REPEATING_BITMAP_FILL        :uint = 0x40;
		public static const CLIPPED_BITMAP_FILL          :uint = 0x41;
		
		public static const NON_SMOOTHED_REPEATING_BITMAP:uint = 0x42;
		public static const NON_SMOOTHED_CLIPPED_BITMAP  :uint = 0x43;
	}
}