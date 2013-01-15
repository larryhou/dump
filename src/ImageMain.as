package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.model.shape.renderers.ShapeRenderer;
	import com.larrio.dump.tags.DefineBitsJPEG3Tag;
	import com.larrio.dump.tags.DefineBitsLosslessTag;
	import com.larrio.dump.tags.DefineBitsTag;
	import com.larrio.dump.tags.DefineFont3Tag;
	import com.larrio.dump.tags.DefineShape3Tag;
	import com.larrio.dump.tags.DefineShapeTag;
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
			
			var includes:Array = [];
			includes.push(TagType.DEFINE_BITS);
			includes.push(TagType.DEFINE_BITS_JPEG2);
			includes.push(TagType.DEFINE_BITS_JPEG3);
			includes.push(TagType.DEFINE_BITS_JPEG4);
			includes.push(TagType.DEFINE_BITS_LOSSLESS);
			includes.push(TagType.DEFINE_BITS_LOSSLESS2);
			swf = new SWFile(bytes);
			
			var alphas:ByteArray;
			
			var index:uint, location:Point = new Point(10, 50);
			
			var loader:Image, bitmap:Bitmap;
			var shape:Shape, fontTag:DefineFont3Tag;
			
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
						
					case TagType.DEFINE_SHAPE:
					case TagType.DEFINE_SHAPE2:
					case TagType.DEFINE_SHAPE3:
					case TagType.DEFINE_SHAPE4:
					{
						//break;
						shape = new Shape();
						shape.x = 300; shape.y = 300;
						shape.scaleX = shape.scaleY = 1 / 10;
						ShapeRenderer.render(shape.graphics, (tag as DefineShapeTag).shape, tag.dict);
						addChild(shape);
						break;
					}
						
					case TagType.DEFINE_FONT3:
					{
						break;
						fontTag = tag as DefineFont3Tag;
						for (var i:int = 0; i < fontTag.glyphs.length; i++)
						{
							index++;
							if (index % 20 == 0)
							{
								location.y += 50;
								location.x = 10;
							}
							
							shape = new Shape();
							shape.graphics.clear();
							shape.graphics.lineStyle(1, 0xFF0000);
							shape.graphics.beginFill(0xFF0000, 0.1);
							
							shape.x = location.x; 
							shape.y = location.y;
							shape.scaleX = shape.scaleY = 1 / 600;
							
							ShapeRenderer.render(shape.graphics, fontTag.glyphs[i], tag.dict);
							addChild(shape);
							
							location.x += 50;
						}
						break;
					}
				}
				
				//if (shape) break;
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