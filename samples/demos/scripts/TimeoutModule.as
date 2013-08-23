package demos.scripts
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Apr 7, 2013 9:50:20 PM
	 */
	public class TimeoutModule extends Sprite
	{
		/**
		 * 构造函数
		 * create a [TimeoutMain] object
		 */
		public function TimeoutModule()
		{
			var index:uint;
			while (true)
			{
				++index;
				trace(getTimer());
			}
		}
	}
}