package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	[SWF(frameRate="60", width="600", height="400")]
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:31:50 PM
	 */
	final dynamic public class Main extends Sprite
	{
		public static const v1:uint = 1;
		private static var v2:uint;
		protected static var v3:String;
		
		[DATA(name="version")]
		public var version:String = "v1.0";
		protected var author:String = "larryhou";
		
		private var data:Class;
		internal var key:*;
		
		/**
		 * 构造函数
		 * create a [Main] object
		 */
		public function Main()
		{		
			var bytes:ByteArray, swf:SWFile;
			
			bytes = loaderInfo.bytes;
			swf = new SWFile(bytes);
			
			bytes = swf.encode();
			assertTrue(equals(bytes, loaderInfo.bytes));
			
			swf = new SWFile(bytes);
			
			var callback:* = function(date:* = "FUCK YOU!"):String
			{
				return String(this);
			}
			
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				if (swf.tags[i].type == DoABCTag.TYPE)
				{
					break;
				}
			}
			
			var abcTag:DoABCTag = swf.tags[i] as DoABCTag;
//			trace(abcTag.abc.constants.strings.join("\n"));
			trace(abcTag.abc.files.join("\n"));
						
			var size:SWFRect = swf.header.size;
			assertTrue(size.width == stage.stageWidth);
			assertTrue(size.height == stage.stageHeight);
			assertTrue(swf.header.frameRate / 256 == stage.frameRate);
		}
		
		// 比较两个字节数组是否相等
		[META(order="2", key="unit")]
		protected function equals(b1:ByteArray, b2:ByteArray):Boolean
		{
			if (b1.length != b2.length) return false;
			b1.position = b2.position = 0;
			while (b1.bytesAvailable)
			{
				if (b1.readByte() != b2.readByte()) return false;
			}
			
			return true;
		}
		
		override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
		{
			return super.getBounds(targetCoordinateSpace);
		}
		
	}
}

class larryhou {}