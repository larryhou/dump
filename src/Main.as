package
{
	import com.larrio.math.sign;
	import com.larrio.math.unsign;
	import com.larrio.utils.ByteDecoder;
	
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
			var num:uint = Math.ceil(0xFF * Math.random());
			trace(num.toString(2));
			
			var bytes:ByteDecoder = new ByteDecoder();
			bytes.writeByte(num);
			
			bytes.position = 0;
			num = bytes.readUB(5);
			
			trace(num.toString(2));
		}
	}
}