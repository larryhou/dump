package builder.sound
{
	import com.larrio.dump.SWFBuilder;
	import com.larrio.dump.SWFile;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.model.sound.mp3.MP3File;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 6:22:31 PM
	 */
	public class MP3Main extends Sprite
	{
		/**
		 * 构造函数
		 * create a [MP3Main] object
		 */
		public function MP3Main()
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest("../libs/sleep.mp3"));
		}
		
		protected function completeHandler(event:Event):void
		{
			var bytes:ByteArray = event.currentTarget.data;
			trace(bytes.length);
			
			var decoder:FileDecoder = new FileDecoder();
			decoder.writeBytes(bytes);
			decoder.position = 0;
			
			var mp3:MP3File = new MP3File(true);
			mp3.decode(decoder);
			trace(mp3);
			
			var builder:SWFBuilder = new SWFBuilder();
			builder.insertMP3(bytes, "com.larrio::SimpleAudio");
			
			var swf:SWFile = new SWFile(builder.export());
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetReadyHandler);
			loader.loadBytes(builder.export(), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function assetReadyHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			var audio:Sound = new (getDefinitionByName("com.larrio.SimpleAudio") as Class)() as Sound;
			audio.play();
			
		}
	}
}