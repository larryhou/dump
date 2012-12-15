package
{
	import com.larrio.math.sign;
	import com.larrio.math.unsign;
	import com.larrio.utils.ByteDecoder;
	import com.larrio.utils.ByteEncoder;
	
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
			
			var decoder:ByteDecoder = new ByteDecoder();
			decoder.writeByte(num);
			
			decoder.position = 0;
			num = decoder.readUB(5);
			
			num = 0x1F2;
			trace(num.toString(2));
			
			var encoder:ByteEncoder = new ByteEncoder();
			encoder.writeUB(num, 9);
			encoder.position = 0;
			
			trace(unsign(encoder.readByte(), 8).toString(2));
			
			num = 0xFFFFFFFF;
			trace(num.toString(16).toUpperCase());
			
			num >>= 8;
			trace(num.toString(16).toUpperCase());

		}
	}
}