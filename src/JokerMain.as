package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.flash.display.shape.canvas.GraphicsCanvas;
	import com.larrio.dump.flash.display.shape.canvas.ICanvas;
	import com.larrio.dump.flash.display.shape.collector.ShapeInfoCollector;
	import com.larrio.dump.flash.display.shape.canvas.SimpleCanvas;
	import com.larrio.dump.flash.display.shape.collector.VectorCollector;
	import com.larrio.dump.tags.DefineShapeTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Mar 25, 2013 3:16:12 PM
	 */
	public class JokerMain extends Sprite
	{
		[Embed(source="../libs/joker.swf", mimeType="application/octet-stream")]
		private var RawFile:Class;

		
		/**
		 * 构造函数
		 * create a [JokerMain] object
		 */
		public function JokerMain()
		{
			var swf:SWFile = new SWFile(new RawFile());
			
			var shapeTag:DefineShapeTag;
			for each(var tag:SWFTag in swf.tags)
			{
				switch(tag.type)
				{
					case TagType.DEFINE_SHAPE:
					case TagType.DEFINE_SHAPE2:
					case TagType.DEFINE_SHAPE3:
					case TagType.DEFINE_SHAPE4:
					{
						shapeTag = tag as DefineShapeTag;
						break;
					}
				}
				
				if (shapeTag) break;
			}
			
			
			var shape:Shape = new Shape();
			shape.scaleX = shape.scaleY = 3;
			addChild(shape);
			
			var collector:VectorCollector = new VectorCollector(shapeTag.shape);
//			var collector:ShapeInfoCollector = new ShapeInfoCollector(shapeTag.shape);
			collector.drawVectorOn(new GraphicsCanvas(shape.graphics));
			
//			trace(collector.components);
			
		}
	}
}