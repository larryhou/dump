package demos.vector 
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
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="#CCCCCC")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Mar 25, 2013 3:16:12 PM
	 */
	public class DrawMain extends Sprite
	{
//		[Embed(source="../../../libs/assets/allcrops/Crop_15/shape-10.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/allcrops/Crop_10/shape-11.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/diy/49/shape-01.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/diy/24/shape-01.swf", mimeType="application/octet-stream")]
		[Embed(source="../../../libs/assets/diy/17/shape-02.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/allcards/Card_2004/shape-06.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/allcards/Card_2008/shape-05.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/allcards/Card_2005/shape-05.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/f0f1.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		private var _steps:Array;
		private var _index:uint;
		
		private var _brush:Graphics;
		private var _container:Shape;
		
		private var _indicator:TextField;
		
		/**
		 * 构造函数
		 * create a [JokerMain] object
		 */
		public function DrawMain()
		{
			_indicator = new TextField();
			_indicator.defaultTextFormat = new TextFormat("Menlo", 20, 0xFF0000, true);
			_indicator.autoSize = TextFieldAutoSize.LEFT;
			_indicator.mouseEnabled = false;
			addChild(_indicator);
			
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
			
			_container = new Shape();
			addChild(_container);
			
			_brush = _container.graphics;
			
			var collector:IShapeCollector;
			collector = new VectorCollector(shapeTag.shape);
			trace(shapeTag.bounds);
//			collector = new ShapeInfoCollector(shapeTag.shape);
			
			var canvas:SimpleCanvas;
			collector.drawVectorOn(canvas = new SimpleCanvas());
			
			var bounds:Rectangle = canvas.bounds;
			trace(bounds);
			
			const MARGIN:Number = 30;
			_container.scaleX = _container.scaleY = Math.min((stage.stageWidth - MARGIN) / bounds.width, (stage.stageHeight - MARGIN) / bounds.height);
			_container.x = (stage.stage.stageWidth - bounds.width * _container.scaleX) / 2 - bounds.x * _container.scaleX;
			_container.y = (stage.stage.stageHeight - bounds.height * _container.scaleY) / 2 - bounds.y * _container.scaleY;
			
			_steps = canvas.steps;
//			trace(JSON.stringify(canvas.steps));
			addEventListener(Event.ENTER_FRAME, frameHandler);
			
//			var timer:Timer = new Timer(100);
//			timer.addEventListener(TimerEvent.TIMER, timerHandler);
//			timer.start();
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			var bounds:Rectangle = _container.getBounds(this);
			_container.x = (stage.stageWidth - bounds.width) / 2;
			_container.y = (stage.stageHeight - bounds.height) / 2;
		}
		
		protected function frameHandler(event:Event = null):void
		{
			if (_index >= _steps.length)
			{
				_indicator.text = "COMPLETE";
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