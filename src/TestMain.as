package
{
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
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte("j", "utf-8");
			
			trace(bytes.length);
			
			bytes.length = 0;
			bytes.writeMultiByte("j", "utf8");
			trace(bytes.length);
			
			var index:int;
			while (index <= 0xFF)
			{
				trace(index + ": " + String.fromCharCode(index));
				index++;
			}
		}		
	}
}