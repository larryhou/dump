package builder.image.classes
{
	import flash.display.BitmapData;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 23, 2013 1:02:10 PM
	 */
	public class SimpleBitmapData extends BitmapData
	{
		/**
		 * 构造函数
		 * create a [SimpleBitmapData] object
		 */
		public function SimpleBitmapData()
		{
			super(0, 0, true, 0x00FFFFFF);
		}
	}
}