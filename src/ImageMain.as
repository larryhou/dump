package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DefineBitsJPEG3Tag;
	import com.larrio.dump.tags.DefineBitsLosslessTag;
	import com.larrio.dump.tags.DefineBitsTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
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
			
			var alphas:ByteArray;
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
						if (tag is DefineBitsJPEG3Tag)
						{
							alphas = (tag as DefineBitsJPEG3Tag).bitmapAlphaData;
						}
						
						addChild(loader = new Image((tag as DefineBitsTag).data, alphas));
						loader.x = position.x;
						loader.y = position.y;
						
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
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.ByteArray;

class Image extends Sprite
{
	private var _alphas:ByteArray;
	
	public function Image(bytes:ByteArray, alphas:ByteArray)
	{
		_alphas = alphas;
		
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		loader.loadBytes(bytes);
		addChild(loader);
	}
	
	protected function completeHandler(e:Event):void
	{
		var bitmap:Bitmap;
		
		// TODO Auto-generated method stub
		bitmap = e.currentTarget.content as Bitmap;
		if (!_alphas) return;
		_alphas.position = 0;
		
		var locX:uint, locY:uint;
		var data:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x00FF0000);
		var src:BitmapData = bitmap.bitmapData;
		
		data.lock();
		src.lock();
		
		var color:uint;
		while (locY < bitmap.height)
		{
			locX = 0;
			while (locX < bitmap.width)
			{
				color = _alphas.readByte() & 0xFF;
				data.setPixel32(locX, locY, color << 24 | src.getPixel(locX, locY));
				locX++;
			}
			
			locY++;
		}
		
		bitmap.bitmapData = data;
	}}