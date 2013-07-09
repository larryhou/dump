package builder
{
	import com.larrio.dump.SWFBuilder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 9, 2013 1:24:56 PM
	 */
	public class InsertMain extends Sprite
	{
		[Embed(source="../libs/img03.png", mimeType="application/octet-stream")]
		private var ImageByteArray:Class;
		
		[Embed(source="../libs/sleep.mp3", mimeType="application/octet-stream")]
		private var MusicByteArray:Class;
		
		[Embed(source="../libs/img01.png", mimeType="application/octet-stream")]
		private var BinaryByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [InsertMain] object
		 */
		public function InsertMain()
		{
			var swf:SWFBuilder = new SWFBuilder();
			swf.insertBinary(new BinaryByteArray(), "binary");
			swf.insertImage(new ImageByteArray(), "image");
			swf.insertMP3(new MusicByteArray(), "music");
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(swf.export(), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function completeHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			
			trace(getDefinitionByName("binary"));
			trace(getDefinitionByName("image"));
			trace(getDefinitionByName("music"));
			
			var image:BitmapData = new (getDefinitionByName("image") as Class)() as BitmapData;
			addChild(new Bitmap(image));
			
			var music:Sound = new (getDefinitionByName("music") as Class)() as Sound;
			music.play();
			
			new FileReference().save(loaderInfo.bytes, "insert.swf");
		}
	}
}