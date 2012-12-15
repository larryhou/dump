package
{
	import com.larrio.math.sign;
	import com.larrio.math.unsign;
	
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:31:50 PM
	 */
	public class Main extends Sprite
	{
		/**
		 * 构造函数
		 * create a [Main] object
		 */
		public function Main()
		{
			var str:String = "1111";
			
			var num:uint = uint(parseInt(str, 2));
			trace(num.toString(2));
			
			var result:int = sign(num, str.length);
			trace(result);
			
			num = unsign(result, str.length);
			trace(num.toString(2));
			
		}
	}
}