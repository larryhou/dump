package builder.image
{
	import com.larrio.dump.SWFBuilder;
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.PlaceObject2Tag;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 10, 2013 1:18:32 PM
	 */
	public class AlphaImageMain extends Sprite
	{
		[Embed(source="../libs/img03.png", mimeType="application/octet-stream")]
		private var FileByteArray:Class;

		/**
		 * 构造函数
		 * create a [AlphaImageMain] object
		 */
		public function AlphaImageMain()
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetReadyHandler);
			loader.loadBytes(new FileByteArray());
		}
		
		protected function assetReadyHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			
			var bytes:ByteArray = loaderInfo.bytes;
			var content:Bitmap = loaderInfo.content as Bitmap;
			
			var swfBuilder:SWFBuilder = new SWFBuilder();
			//swfBuilder.insertJPEG(content.bitmapData, "com.larrio::AlphaImage", 80);
			swfBuilder.insertAlphaJPEG(content.bitmapData, "com.larrio::AlphaImage", 80);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(swfBuilder.export(), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function completeHandler(event:Event):void
		{
			var data:BitmapData = new (getDefinitionByName("com.larrio.AlphaImage") as Class)() as BitmapData;
			addChild(new Bitmap(data));
			
			trace(data.getPixel32(50, 50).toString(16).toUpperCase());
		}
	}
}