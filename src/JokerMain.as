package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.model.shape.renderers.DrawSimulator;
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
			
			
			trace(shapeTag);
			
			var canvas:Shape = new Shape();
			canvas.scaleX = canvas.scaleY = 0.1;
			addChild(canvas);
			
			var simulator:DrawSimulator = new DrawSimulator(canvas.graphics, shapeTag.shape, shapeTag.dict);
			simulator.start();
			
		}
	}
}