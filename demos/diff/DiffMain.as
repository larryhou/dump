package diff
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	/**
	 * SWF比对
	 * @author larryhou
	 * @createTime Jul 9, 2013 3:27:22 PM
	 */
	public class DiffMain extends Sprite
	{
		[Embed(source="../libs/lib01.swf", mimeType="application/octet-stream")]
		private var FileByteArray1:Class;
		
		[Embed(source="../libs/lib02.swf", mimeType="application/octet-stream")]
		private var FileByteArray2:Class;
		
		/**
		 * 构造函数
		 * create a [DiffMain] object
		 */
		public function DiffMain()
		{
			var swf1:SWFile = new SWFile(new FileByteArray1());
			var swf2:SWFile = new SWFile(new FileByteArray2());
			
			var removeTypes:Array = [];
			removeTypes.push(TagType.META_DATA);
			removeTypes.push(TagType.ENABLE_DEBUGGER);
			removeTypes.push(TagType.ENABLE_DEBUGGER2);
			removeTypes.push(TagType.IMPORT_ASSETS);
			removeTypes.push(TagType.IMPORT_ASSETS2);
			removeTypes.push(TagType.PRODUCT_INFO);
			removeTypes.push(TagType.DEBUG_ID);
			removeTypes.push(TagType.PROTECT);
			
			removeTags(swf1, removeTypes);
			removeTags(swf2, removeTypes);
			
			var result:Boolean = compare(swf1.repack(), swf2.repack());
			trace("result:" + result);
		}
				
		private function removeTags(swf:SWFile, types:Array):void
		{
			var dict:Dictionary = new Dictionary();
			for each (var type:uint in types) dict[type] = true;
			
			var tag:SWFTag;
			for (var i:int = 0, length:uint = swf.tags.length; i < length; i++)
			{
				tag = swf.tags[i];
				if (dict[tag.type])
				{
					swf.tags.splice(i--, 1);
					length--;
					continue;
				}
			}
		}
		
		private function compare(bytes1:ByteArray, bytes2:ByteArray):Boolean
		{
			if (bytes1.length != bytes2.length) 
			{
				trace("length not same: " + bytes1.length + ", " + bytes2.length);
				return false;
			}
			
			bytes1.position = bytes2.position = 0;
			
			var index:uint;
			while (bytes1.bytesAvailable)
			{
				if (bytes1.readUnsignedByte() != bytes2.readUnsignedByte()) 
				{
					trace("offset: " + bytes1.position + ", total: " + bytes1.length);
					return false;
				}
			}
			
			return true;
		}
	}
}