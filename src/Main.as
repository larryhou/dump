package
{
	import com.larrio.math.sign;
	import com.larrio.math.unsign;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	
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
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0xFF);
			
			bytes.position = 0;
			var num:uint = bytes.readByte() & 0xFF;
			
			trace(num.toString(16).toUpperCase());
						
		}
	}
}