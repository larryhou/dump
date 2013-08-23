package demos.builder.sound
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Sprite;
	import flash.net.FileReference;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 3, 2013 5:56:18 PM
	 */
	public class SoundABCMain extends Sprite
	{
		[Embed(source="classes/class.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [SoundMain] object
		 */
		public function SoundABCMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray());
			
			var abcTag:DoABCTag;
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC)
				{
					abcTag = tag as DoABCTag;
					if (abcTag.name.match(/SimpleSound$/))
					{
						saveDoABCTag(tag);
						break;
					}
				}
				
			}
		}
				
		private function saveDoABCTag(tag:SWFTag):void
		{
			var encoder:FileEncoder = new FileEncoder();
			tag.encode(encoder);
			
			new FileReference().save(encoder, "tag.abc");
		}
		
	}
}