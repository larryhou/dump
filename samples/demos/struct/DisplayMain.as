package demos.struct
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DefineShapeTag;
	import com.larrio.dump.tags.PlaceObject2Tag;
	import com.larrio.dump.tags.SWFTag;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	[SWF(width="800", height="600")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Apr 8, 2013 12:17:55 AM
	 */
	public class DisplayMain extends Sprite
	{
		[Embed(source="../../../libs/joker.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;

		/**
		 * 构造函数
		 * create a [DisplayMain] object
		 */
		public function DisplayMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray());
			
			for each (var tag:SWFTag in swf.tags)
			{
				if (tag is DefineShapeTag) break;
			}
			
			var place:PlaceObject2Tag = new PlaceObject2Tag();
			place.character = tag.character;
			place.depth = 1;
			
			var matrix:Matrix = new Matrix();
			matrix.scale(2, 2);
			matrix.tx = 200;
			matrix.ty = -10;
			
			place.matrix = matrix;
			trace(place.toString());
			
			var index:uint = swf.tags.indexOf(tag);
			swf.tags.splice(index + 1, 0, place);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(swf.repack());
		}
		
		protected function completeHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			addChild(loaderInfo.content);
			
			var swf:SWFile = new SWFile(loaderInfo.bytes);
			trace(swf);
		}
	}
}