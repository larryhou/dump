package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DefineBitsJPEG3Tag;
	import com.larrio.dump.tags.DefineBitsLosslessTag;
	import com.larrio.dump.tags.DefineBitsTag;
	import com.larrio.dump.tags.DefineShape3Tag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 12, 2013 10:56:25 PM
	 */
	public class ImageMain extends Sprite
	{
		[Embed(source="../libs/res04.swf", mimeType="application/octet-stream")]
		private var RawFile:Class;
		
		/**
		 * 构造函数
		 * create a [ImageMain] object
		 */
		public function ImageMain()
		{
			var bytes:ByteArray, swf:SWFile;
			var rawFile:ByteArray = loaderInfo.bytes;
			//rawFile = new RawFile();
			
			bytes = rawFile;
			
			var includes:Array = [];
			includes.push(TagType.DEFINE_BITS);
			includes.push(TagType.DEFINE_BITS_JPEG2);
			includes.push(TagType.DEFINE_BITS_JPEG3);
			includes.push(TagType.DEFINE_BITS_JPEG4);
			includes.push(TagType.DEFINE_BITS_LOSSLESS);
			includes.push(TagType.DEFINE_BITS_LOSSLESS2);
			swf = new SWFile(bytes);
			
			var alphas:ByteArray;
			
			var shape:Shape;
			var loader:Image, bitmap:Bitmap;
			var position:Point = new Point();
			for each(var tag:SWFTag in swf.tags)
			{
				alphas = null;
				switch(tag.type)
				{
					case TagType.DEFINE_BITS:
					case TagType.DEFINE_BITS_JPEG2:
					case TagType.DEFINE_BITS_JPEG3:
					case TagType.DEFINE_BITS_JPEG4:
					{
						break;
						addChild(loader = new Image(tag as DefineBitsTag));
						
						loader.x = position.x;
						loader.y = position.y;
						
						position.x += 10;
						position.y += 10;
						trace(tag);

						break;
					}
						
					case TagType.DEFINE_BITS_LOSSLESS:
					case TagType.DEFINE_BITS_LOSSLESS2:
					{
						break;
						bitmap = new Bitmap();
						bitmap.bitmapData = (tag as DefineBitsLosslessTag).data;
						bitmap.x = position.x;
						bitmap.y = position.y;
						addChild(bitmap);
						
						position.x += 10;
						position.y += 10;

						break;
					}
						
					case TagType.DEFINE_SHAPE3:
					{
						shape = new Shape();
						shape.x = 300; shape.y = 300;
						shape.scaleX = shape.scaleY = 1 / 10;
						(tag as DefineShape3Tag).shape.draw(shape.graphics);
						addChild(shape);
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