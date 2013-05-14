package crop
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.PlaceObject2Tag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.SymbolClassTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime May 14, 2013 5:24:52 PM
	 */
	public class CropMain extends Sprite
	{
		[Embed(source="../libs/crop.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;

		/**
		 * 构造函数
		 * create a [CropMain] object
		 */
		public function CropMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray());
			
			var adder:PlaceObject2Tag;
			var tag:SWFTag, symbol:SymbolClassTag;
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				tag = swf.tags[i];
				if (tag.type == TagType.DO_ABC)
				{
					swf.tags.splice(i--, 1);
					continue;
				}
				
				if (tag.type == TagType.SYMBOL_CLASS)
				{
					symbol = tag as SymbolClassTag;
					
					for (var j:int = 0; j < symbol.ids.length; j++)
					{
						if (symbol.ids[j])
						{
							adder = new PlaceObject2Tag();
							adder.character = symbol.ids[j];
							adder.depth = 1;
							swf.tags.splice(i, 1, adder);
							break;
						}
					}
				}
			}
			
			var bytes:ByteArray = swf.repack();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(bytes);
		}
		
		protected function completeHandler(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			addChild(loaderInfo.content);
			
		}
	}
}