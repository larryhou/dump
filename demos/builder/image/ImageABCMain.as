package builder.image
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Sprite;
	import flash.net.FileReference;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 1:38:51 PM
	 */
	public class ImageABCMain extends Sprite
	{
		[Embed(source="../libs/image.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [ImageMain] object
		 */
		public function ImageABCMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray());
			trace(swf);
			
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC)
				{
					saveDoABCTag(tag);
					break;
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