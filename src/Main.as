package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.math.fixed;
	import com.larrio.math.sign;
	import com.larrio.math.unfixed;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
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
		//[Embed(source="../libs/library.swf", symbol="CollectingMainWindowMC")]
		//private const _cls : Class;
		
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
			
			bytes = swf.repack();
			//assertTrue(bytes.length == loaderInfo.bytes.length);
			assertTrue(equals(bytes, loaderInfo.bytes));
			//new FileReference().save(bytes, "encode.swf");
			
			swf = new SWFile(bytes);
			
			var callback:* = function(date:* = "FUCK YOU!"):String
			{
				return String(this);
			}
			
			var tag:DoABCTag;
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				if (swf.tags[i].type == DoABCTag.TYPE)
				{
					tag = swf.tags[i] as DoABCTag;
					//trace("\n\n-----------------------------------------\n");
					//trace(tag.abc.constants.strings.join("\n"));
					//trace(tag.abc.files.join("\n"));
					break;
				}
			}
						
			var size:SWFRect = swf.header.size;
			assertTrue(size.width == stage.stageWidth);
			assertTrue(size.height == stage.stageHeight);
			assertTrue(swf.header.frameRate / 256 == stage.frameRate);
			
			var shape:Sprite = new Sprite();
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.drawRect(0, 0, 300, 200);
			shape.scale9Grid = new Rectangle(10, 10, 280, 180);
			
			var result:Number = 2.125;
			//fixed(0x7FFFFFFF, 24, 8);
			//trace(result);
			
			var num:uint = unfixed(result, 4, 28);
			trace(num.toString(16).toUpperCase());
			trace(fixed(num, 4, 28));
		}
		
		// 比较两个字节数组是否相等
		[META(order="2", key="unit")]
		protected function equals(b1:ByteArray, b2:ByteArray):Boolean
		{
			var v1:int, v2:int;
			b1.position = b2.position = 0;
			while (b1.bytesAvailable)
			{
				v1 = b1.readByte();
				v2 = b2.readByte();
				if (v1 != v2)
				{
					trace("byte:" + v1 + " " + v2 + ", offset:" + b1.position);
					return false;
				}
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