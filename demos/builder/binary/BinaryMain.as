package builder.binary
{
	import com.larrio.dump.SWFBuilder;
	
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
	 * @createTime Jul 9, 2013 1:12:22 PM
	 */
	public class BinaryMain extends Sprite
	{
		[Embed(source="../libs/img03.png", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [BinaryMain] object
		 */
		public function BinaryMain()
		{
			var swf:SWFBuilder = new SWFBuilder();
			swf.insertBinary(new FileByteArray(), "com.larrio::SimpleBinary");
			swf.insertBinary(new FileByteArray(), "com.larrio.Binary");
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(swf.export(), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function completeHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			
			trace(loaderInfo.applicationDomain.getDefinition("com.larrio::SimpleBinary"));
			
			var data:ByteArray = new (getDefinitionByName("com.larrio::Binary") as Class)() as ByteArray;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetReadyHandler);
			loader.loadBytes(data, new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function assetReadyHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			addChild(loaderInfo.content);
		}
	}
}