package
{
	import com.larrio.math.sign;
	import com.larrio.math.unsign;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	import com.larrio.utils.assertTrue;
	
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
			loop();
		}
		
		private function loop(index:int = 1):void
		{
			if (index >= 100)return;
			
			var num:uint = uint.MAX_VALUE * Math.random() >> 0;
			
			var encoder:FileEncoder = new FileEncoder();
			encoder.writeES32(num);
			
			var decoder:FileDecoder = new FileDecoder();
			decoder.writeBytes(encoder);
			
			decoder.position = 0;
			var result:uint = decoder.readEU32();
			
			assertTrue(num == result);
			
			arguments.callee(++index);
		}
	}
}