package draw
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.flash.display.shape.canvas.SimpleCanvas;
	import com.larrio.dump.flash.display.shape.collector.IShapeCollector;
	import com.larrio.dump.flash.display.shape.collector.VectorCollector;
	import com.larrio.dump.tags.DefineShapeTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="1024", height="768", frameRate="60")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Mar 25, 2013 3:16:12 PM
	 */
	public class DrawMain extends Sprite
	{
		[Embed(source="../libs/joker.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		private var _steps:Array;
		private var _index:uint;
		
		private var _brush:Graphics;
		
		/**
		 * 构造函数
		 * create a [JokerMain] object
		 */
		public function DrawMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray());
			
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
			
			_brush = shape.graphics;
			
			var collector:IShapeCollector;
			collector = new VectorCollector(shapeTag.shape);
//			collector = new ShapeInfoCollector(shapeTag.shape);
			
			var canvas:SimpleCanvas;
			collector.drawVectorOn(canvas = new SimpleCanvas());
			
			_steps = canvas.steps;
			addEventListener(Event.ENTER_FRAME, frameHandler);
			
		}
		
		protected function frameHandler(event:Event = null):void
		{
			if (_index >= _steps.length)
			{
				removeEventListener(Event.ENTER_FRAME, arguments.callee);
				return;
			}
			
			var step:Object = _steps[_index++];
			(_brush[step.method] as Function).apply(null, step.params);
			switch(step.method)
			{
				case "moveTo": //case "lineTo": case "curveTo":
				{
					arguments.callee();
					break;
				}
			}
		}
	}
}