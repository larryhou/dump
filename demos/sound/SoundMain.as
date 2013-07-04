package sound
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.tags.DefineSoundTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 3, 2013 5:56:18 PM
	 */
	public class SoundMain extends Sprite
	{
		[Embed(source="../libs/S01.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [SoundMain] object
		 */
		public function SoundMain()
		{
			//setup();
			
			verify();
		}
		
		private function setup():void
		{
			var soundTag:DefineSoundTag;
			var swf:SWFile = new SWFile(new FileByteArray());
			//			var swf:SWFile = new SWFile(loaderInfo.bytes);
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DEFINE_SOUND)
				{
					soundTag = tag as DefineSoundTag;
					trace(soundTag);
					
					soundTag.sampleCount = 10000;
					
					//new FileReference().save((tag as DefineSound).data, "extract.mp3");
					break;
				}
			}
			
			new FileReference().save(swf.repack(), "S02.swf");
		}
		
		private function countSamples(mp3:ByteArray):uint
		{
			
			
			return 0;
		}
		
		private function verify():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest("../libs/S02.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function completeHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			var cls:Class = loaderInfo.applicationDomain.getDefinition("larrio") as Class;
			var s:Sound = new cls();
			s.play();
			
			trace(s);
		}
	}
}