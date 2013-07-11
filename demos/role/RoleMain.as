package role
{
	import com.larrio.dump.SWFBuilder;
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DefineBitsJPEG2Tag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.SymbolClassTag;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 10, 2013 10:19:37 AM
	 */
	public class RoleMain extends Sprite
	{
		[Embed(source="../libs/role.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [RoleMain] object
		 */
		public function RoleMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray(), []);
			trace(swf);
			
			var character:uint;
			for each(var symbol:SymbolClassTag in swf.symbolTags)
			{
				for (var i:int = 0; i < symbol.symbols.length; i++)
				{
					if (symbol.symbols[i] == "Asset_13")
					{
						character = symbol.ids[i];
						break;
					}
				}
			}
			
			if (character)
			{
				var tag:SWFTag = swf.dict[character];
				if (tag)
				{
					var swfBuilder:SWFBuilder = new SWFBuilder();
					swfBuilder.insertImageByTag(tag, "role");
					
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
					loader.loadBytes(swfBuilder.export(), new LoaderContext(false, ApplicationDomain.currentDomain));
				}
				
			}
		}
		
		protected function completeHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			
			var image:BitmapData = new (getDefinitionByName("role") as Class)() as BitmapData;
			addChild(new Bitmap(image));
			
			var swf:SWFile = new SWFile(loaderInfo.bytes);
			new FileReference().save(loaderInfo.bytes, "image.role.swf");
		}
	}
}