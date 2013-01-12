package
{
	import com.larrio.dump.utils.hexSTR;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
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
			var src:ByteArray = new ByteArray();
			
			var index:uint;
			while (index <= 0xFF) src.writeByte(index++);
			
			src.position = 0;
			
			var dst:ByteArray = new ByteArray();
			src.readBytes(dst, 0, 4);
			
			trace(dst.length, dst[0]);
		}		
	}
}