package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.doabc.MethodFlagType;
	import com.larrio.dump.doabc.MultiKindType;
	import com.larrio.dump.doabc.NSKindType;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	import com.larrio.math.sign;
	import com.larrio.math.unsign;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	import com.larrio.utils.assertTrue;
	import com.larrio.utils.printTypes;
	
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
			
			var tags:Vector.<SWFTag> = swf.tags;
			for each(var t:SWFTag in tags)
			{
				if (t.type == TagType.DO_ABC)
				{
					break;
				}
			}
			
			(t as DoABCTag).print();
			
			printTypes(MethodFlagType, 40);
			
		}
		
		private function padding(str:String, length:int):String
		{
			while(str.length < length) str += " ";
			return str;
		}
		
	}
}