package demos.scripts
{
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Apr 7, 2013 9:51:01 PM
	 */
	public class RecursionModule extends Sprite
	{
		
		/**
		 * 构造函数
		 * create a [RecursionMain] object
		 */
		public function RecursionModule()
		{
			recursive();
		}
		
		private function recursive(loop:uint = 0):uint
		{
			//~/library/Preferences/Macromedia/Flash Player/Logs
			trace((new Date().time / 1000 >> 0) + ":" + loop);
			return recursive(++loop);
		}
	}
}