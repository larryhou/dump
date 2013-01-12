package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DefineBitsLosslessTag;
	import com.larrio.dump.tags.DefineBitsTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	[SWF(width="800", height="600")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 12, 2013 10:56:25 PM
	 */
	public class ImageMain extends Sprite
	{
		[Embed(source="../libs/res01.swf", mimeType="application/octet-stream")]
		private var RawFile:Class;
		
		/**
		 * 构造函数
		 * create a [ImageMain] object
		 */
		public function ImageMain()
		{
			var bytes:ByteArray, swf:SWFile;
			var rawFile:ByteArray = loaderInfo.bytes;
			rawFile = new RawFile();
			
			bytes = rawFile;
			swf = new SWFile(bytes);
			
			var loader:Loader, bitmap:Bitmap;
			var position:Point = new Point();
			for each(var tag:SWFTag in swf.tags)
			{
				switch(tag.type)
				{
					case TagType.DEFINE_BITS:
					case TagType.DEFINE_BITS_JPEG2:
					case TagType.DEFINE_BITS_JPEG3:
					{
						addChild(loader = new Loader());
						loader.x = position.x;
						loader.y = position.y;
						loader.loadBytes((tag as DefineBitsTag).data);
						
						position.x += 30;
						position.y += 30;

						break;
					}
						
					case TagType.DEFINE_BITS_LOSSLESS:
					case TagType.DEFINE_BITS_LOSSLESS2:
					{
						bitmap = new Bitmap();
						bitmap.bitmapData = (tag as DefineBitsLosslessTag).data;
						bitmap.x = position.x;
						bitmap.y = position.y;
						addChild(bitmap);
						
						position.x += 30;
						position.y += 30;

						break;
					}
				}
				
			}
			
		}
	}
}