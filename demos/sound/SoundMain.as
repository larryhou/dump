package sound
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DefineSoundTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Sprite;
	import flash.net.FileReference;
	import flash.text.engine.BreakOpportunity;
	
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
			var swf:SWFile = new SWFile(new FileByteArray());
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DEFINE_SOUND)
				{
					trace(tag);
					//new FileReference().save((tag as DefineSound).data, "extract.mp3");
					break;
				}
			}
			trace(swf);
		}
	}
}