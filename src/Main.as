package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.tags.TagType;
	import com.larrio.math.sign;
	import com.larrio.math.unsign;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	import com.larrio.utils.assertTrue;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	
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
			
			var list:Array = [];
			
			var key:String, type:int,item:Object;
			var map:Dictionary = new Dictionary();
			var config:XMLList = describeType(TagType).constant;
			for each(var node:XML in config)
			{
				key = String(node.@name);
				type = TagType[key];
				
				assertTrue(map[type] == null);
				
				map[type] = key;
				list.push(item = {name:key});
				item.data = padding("public static const " + key, 55) + ":uint = " + padding("0x" + type.toString(16).toUpperCase() + ";", 5) + " // " + type;
			}
			
			list.sortOn("name");
			while(list.length)
			{
				trace(list.shift().data);
			}
		}
		
		private function padding(str:String, length:int):String
		{
			while(str.length < length) str += " ";
			return str;
		}
		
	}
}