package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.utils.assertTrue;
	
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
			var swf:SWFile = new SWFile(loaderInfo.bytes);
			swf.decode();
			
			var size:SWFRect = swf.header.size;
			assertTrue(size.width == stage.stageWidth);
			assertTrue(size.height == stage.stageHeight);
			assertTrue(swf.header.frameRate / 256 == stage.frameRate);
		}
		
		private function padding(str:String, length:int):String
		{
			while(str.length < length) str += " ";
			return str;
		}
		
	}
}

class larryhou {}