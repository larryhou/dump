package script
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
			trace(loop);
			
			var callback:Function = function ():uint
			{
				return recursive(++loop);
			}
			return callback.call();
		}
	}
}