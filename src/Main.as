package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	[SWF(frameRate="60", width="600", height="400")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 15, 2012 2:31:50 PM
	 */
	final dynamic public class Main extends Sprite
	{		
		[Embed(source="../libs/res01.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		public static const v1:uint = 1;
		private static var v2:uint;
		protected static var v3:String;
		
		[DATA(name="version")]
		public var version:String = "v1.0";
		protected var author:String = "larryhou";
		
		private var data:Class;
		internal var key:*;
		
		private var _id:String;
		
		private var _callback:Function;
		
		/**
		 * 构造函数
		 * create a [Main] object
		 */
		public function Main()
		{		
			var bytes:ByteArray;
			bytes = loaderInfo.bytes;
			bytes = new FileByteArray();
			
			var swf:SWFile = new SWFile(bytes);
			
			trace(swf.header);
			
			bytes = swf.repack();
			//new FileReference().save(bytes, "encode.swf");
			
			swf = new SWFile(bytes);
			trace(swf.header);
			
			var callback:* = function(date:* = "OptionValue"):String
			{
				return String(this);
			}
			
			var tag:DoABCTag;
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				if (swf.tags[i].type == DoABCTag.TYPE)
				{
					tag = swf.tags[i] as DoABCTag;
					trace("\n\n-----------------------------------------\n");
					//trace(tag.abc.constants.strings.join("\n"));
					trace(tag.abc.files.join("\n"));
					break;
				}
			}
			
		}
		
		public function startUp():void
		{
			
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

		public function get id():String { return _id; }
		public function set id(value:String):void
		{
			_id = value;
		}

		
	}
}

class larryhou {}