package sound
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.model.sound.mp3.MP3File;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
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
			
		}
	}
}