package builder.image
{
	import com.larrio.dump.SWFBuilder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 2:11:20 PM
	 */
	public class PNGMain extends Sprite
	{
		[Embed(source="../libs/img02.png", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [PNGMain] object
		 */
		public function PNGMain()
		{
			var bytes:ByteArray = new FileByteArray();
			
			var swf:SWFBuilder = new SWFBuilder();
			swf.insertImage(bytes, "com.larrio::SimpleImage");
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(swf.export(), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function completeHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			trace(loaderInfo.applicationDomain.getDefinition("com.larrio::SimpleImage"));
			
			var image:BitmapData = new (getDefinitionByName("com.larrio.SimpleImage") as Class)() as BitmapData;
			addChild(new Bitmap(image));
			
			trace(image.getPixel32(5,5).toString(16).toUpperCase());
		}
	}
}