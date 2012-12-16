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
			
			var key:String, type:int;
			var map:Dictionary = new Dictionary();
			var config:XMLList = describeType(TagType).constant;
			for each(var node:XML in config)
			{
				key = String(node.@name);
				type = TagType[key];
				
				assertTrue(map[type] == null);
				
				map[type] = key;
				trace(padding("public static const " + key, 55) + ":uint = 0x" + type.toString(16).toUpperCase() + ";\t// " + type);
			}
		}
		
		private function padding(str:String, length:int):String
		{
			while(str.length < length) str += " ";
			return str;
		}
		
	}
}