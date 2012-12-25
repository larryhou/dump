package
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.math.float;
	import com.larrio.math.unfloat;
	
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 3:05:12 AM
	 */
	public class TestMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [TestMain] object
		 */
		public function TestMain()
		{
			var value:Number = -0.13998;
			var bytes:FileDecoder = new FileDecoder();
			bytes.writeFloat(value);
			bytes.position = 0;
			
			trace(bytes.readFloat());
			
			bytes.position = 0;
			trace(bytes.readUnsignedInt().toString(2));
			
			var num:uint = unfloat(value, 32, 8);
			trace(num.toString(2));
			
			var result:Number = float(num, 32, 8);
			trace(result);
		}		
	}
}