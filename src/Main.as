package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:31:50 PM
	 */
	public class Main extends Sprite
	{
		public static var v1:uint;
		private static var v2:uint;
		protected static var v3:String;
		
		public var version:String = "v1.0";
		protected var author:String = "larryhou";
		
		private var data:Class;
		
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
			
			var callback:Function = function (data:Object):void
			{
				trace(data);
				
				var image:Sprite = new Sprite;
				trace(image.name);
				
				var fuck:Function = function(name:String):void
				{
					trace("Fuck You!" + name);
					
					var callback:Function = function(value:uint):String
					{
						return value.toString();
					}
				}
			};
			
			var container:Sprite = new Sprite();
			container["name"] = "dump";
			
			var test:ByteArray = new ByteArray;
			
			var list:Array = [];
			for (var i:int = 0; i < 100; i++) list.push(i);
		}
		
		private function padding(str:String, length:int):String
		{
			while(str.length < length) str += " ";
			return str;
		}
		
	}
}

class larryhou {}