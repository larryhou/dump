package 
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DefineBitsJPEG3Tag;
	import com.larrio.dump.tags.DefineBitsLosslessTag;
	import com.larrio.dump.tags.DefineBitsTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 12, 2013 10:56:25 PM
	 */
	public class ImageMain extends Sprite
	{
		[Embed(source="../libs/res04.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [ImageMain] object
		 */
		public function ImageMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray(), []);
			
			var index:uint; 
			var location:Point = new Point(10, 50);
			
			var loader:Image, bitmap:Bitmap;
			var position:Point = new Point();
			
			for each(var tag:SWFTag in swf.tags)
			{
				switch(tag.type)
				{
					case TagType.DEFINE_BITS:
					case TagType.DEFINE_BITS_JPEG2:
					case TagType.DEFINE_BITS_JPEG3:
					case TagType.DEFINE_BITS_JPEG4:
					{
						addChild(loader = new Image(tag as DefineBitsTag));
						
						loader.x = position.x;
						loader.y = position.y;
						
						position.x += 10;
						position.y += 10;
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
						
						position.x += 10;
						position.y += 10;

						break;
					}
						
				}
				
			}
			
		}
	}
}
import com.larrio.dump.tags.DefineBitsJPEG3Tag;
import com.larrio.dump.tags.DefineBitsTag;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;

class Image extends Sprite
{
	public function Image(tag:DefineBitsTag)
	{
		var loader:Loader;
		addChild(loader = new Loader());
		
		var bitmap:Bitmap;
		var jpeg:DefineBitsJPEG3Tag = tag as DefineBitsJPEG3Tag;
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
		{
			bitmap = e.currentTarget.content as Bitmap;
			if (jpeg)
			{
				bitmap.bitmapData = jpeg.blendAlpha(bitmap.bitmapData);
			}
		});
		
		loader.loadBytes(tag.data);

	}
}