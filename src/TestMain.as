package
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.math.float;
	import com.larrio.math.unfloat;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 3:05:12 AM
	 */
	public class TestMain extends Sprite
	{
		[Embed(source="../libs/library.swf", mimeType="application/octet-stream")]
		private var _data:Class;
		
		/**
		 * 构造函数
		 * create a [TestMain] object
		 */
		public function TestMain()
		{
			var bytes:ByteArray = new _data();
			trace(bytes.length);
		}		
	}
}