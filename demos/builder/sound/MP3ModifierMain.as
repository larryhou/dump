package builder.sound
{
	import com.larrio.dump.SWFBuilder;
	import com.larrio.dump.SWFile;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.model.sound.mp3.MP3File;
	import com.larrio.dump.tags.SWFTag;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 16, 2013 7:31:20 PM
	 */
	public class MP3ModifierMain extends Sprite
	{
		[Embed(source="../libs/short.mp3", mimeType="application/octet-stream")]
		private var MP3ByteArray:Class;
		
		[Embed(source="../libs/mp3.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;

		
		/**
		 * 构造函数
		 * create a [MP3ModifierMain] object
		 */
		public function MP3ModifierMain()
		{
			var mp3:MP3File = new MP3File(true);
			mp3.decode(new MP3ByteArray());
			trace(mp3);
			
			var tag:SWFTag;
			var swf:SWFile = new SWFile(new FileByteArray());
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				if (swf.tags[i].type == 45)
				{
					swf.tags.splice(i, 1);
					break;
				}
			}
			
			var creator:SWFBuilder = new SWFBuilder();
			creator.insertMP3(new MP3ByteArray(), "short::mp3");			
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(creator.export(), new LoaderContext(false, ApplicationDomain.currentDomain));
			
			var bytes:FileDecoder = new FileDecoder();
			bytes.writeByte(0xFF);
			bytes.position = 0;
			
			trace(bytes[0]);
		}
		
		protected function completeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			var sound:Sound = new (getDefinitionByName("short.mp3") as Class)() as Sound;
			sound.play();
		}
	}
}