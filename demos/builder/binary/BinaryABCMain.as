package builder.binary
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
	 * @createTime Jul 9, 2013 9:58:03 AM
	 */
	public class BinaryABCMain extends Sprite
	{
		[Embed(source="../bin/BinaryFileMain.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [BinaryABCMain] object
		 */
		public function BinaryABCMain()
		{
			var abcTag:DoABCTag;
			var swf:SWFile = new SWFile(new FileByteArray());
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC)
				{
					abcTag = tag as DoABCTag;
					if (abcTag.name.indexOf("SimpleByteArray") > 0)
					{
						trace(abcTag.name);
						saveDoABCTag(abcTag);
						break;
						
					}
				}
			}
			trace(swf);
		}
		
		private function saveDoABCTag(tag:SWFTag):void
		{
			var encoder:FileEncoder = new FileEncoder();
			tag.encode(encoder);
			
			new FileReference().save(encoder, "tag.abc");
		}

	}
}