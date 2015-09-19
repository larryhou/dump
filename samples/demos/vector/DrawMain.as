package demos.vector 
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.flash.display.shape.canvas.ContainerCanvas;
	import com.larrio.dump.flash.display.shape.canvas.JSONCanvas;
	import com.larrio.dump.flash.display.shape.canvas.SVGImageCanvas;
	import com.larrio.dump.flash.display.shape.canvas.StepRecordCanvas;
	import com.larrio.dump.flash.display.shape.collector.IShapeCollector;
	import com.larrio.dump.flash.display.shape.collector.VectorCollector;
	import com.larrio.dump.tags.DefineShapeTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
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
		[Embed(source="../../../libs/assets/diy/49/shape-01.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/diy/17/shape-02.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/allcards/Card_2005/shape-05.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/assets/dogs/FDog13/shape-27.swf", mimeType="application/octet-stream")]
//		[Embed(source="../../../libs/f0f1.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
//		[Embed(source="../../../bin/crops/crops.cfg", mimeType="application/octet-stream")]
//		[Embed(source="../../../bin/diys/diys.cfg", mimeType="application/octet-stream")]
		[Embed(source="../../../bin/shapes/shapes.cfg", mimeType="application/octet-stream")]
		private var CfgByteArray:Class;
		
		private var _steps:Array;
		private var _index:uint;
		
		private var _brush:Graphics;
		private var _container:Shape;
		
		private var _indicator:TextField;
		
		private var _assets:Dictionary;
		private var _answer:String;
		
		/**
		 * 构造函数
		 * create a [JokerMain] object
		 */
		public function DrawMain()
		{
			_indicator = new TextField();
			_indicator.defaultTextFormat = new TextFormat("Menlo", 50, 0xFF0000, true);
			_indicator.autoSize = TextFieldAutoSize.LEFT;
			_indicator.mouseEnabled = false;
			addChild(_indicator);
			
			_assets = new Dictionary(false);
			
			var data:ByteArray = new CfgByteArray();
			var cfg:String = data.readMultiByte(data.length, "UTF-8");
			var list:Array = cfg.split("\n").filter(function(item:String, ...args):Boolean
			{
				return item.length > 0;
			});
			
			_assets = new Dictionary(false);
			for (var i:int = 0; i < list.length; i++)
			{
				var item:Array = list[i].split("\t");
				_assets[item[0]] = item.slice(1);
			}
			
			randomCropSWF();
//			processSWFBytes(new FileByteArray());
			
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
			if (e.ctrlKey)
			{
				randomCropSWF();
			}
		}
		
		private function randomCropSWF():void
		{
			_brush && _brush.clear();
			
			var list:Array = [];
			for (var key:String in _assets)
			{
				list.push(key);
			}
			
			if (!list.length)
			{
				_indicator.text = "EMPTY";
				return;
			}
			
			var index:int = list.length * Math.random() >> 0;
			key = list[index];
			
			var item:Array = _assets[key];
			
			_indicator.text = "";
			_answer = item[1];
			_index = 0;
			
			delete _assets[key];
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest(item[0]));
		}
		
		private function completeHandler(e:Event):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, completeHandler);
			
			processSWFBytes(loader.data as ByteArray);
		}
		
		private function processSWFBytes(data:ByteArray):void
		{
			var swf:SWFile = new SWFile(data);
			
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
			
			_container ||= new Shape();
			addChild(_container);
			
			_brush = _container.graphics;
			
			var collector:IShapeCollector;
			collector = new VectorCollector(shapeTag.shape);
			trace(shapeTag.bounds);
			
			var recordCanvas:StepRecordCanvas, jsonCanvas:JSONCanvas, svgCanvas:SVGImageCanvas;
			var canvasContainer:ContainerCanvas = new ContainerCanvas();
			canvasContainer.addCanvas(recordCanvas = new StepRecordCanvas());
			canvasContainer.addCanvas(jsonCanvas = new JSONCanvas());
			canvasContainer.addCanvas(svgCanvas = new SVGImageCanvas());
			collector.drawVectorOn(canvasContainer);
			trace(jsonCanvas.jsonObject);
			trace(svgCanvas.export());
			
			var bounds:Rectangle = recordCanvas.bounds;
			trace(bounds);
			
			const MARGIN:Number = 30;
			_container.scaleX = _container.scaleY = Math.min((stage.stageWidth - MARGIN) / bounds.width, (stage.stageHeight - MARGIN) / bounds.height);
			_container.x = (stage.stage.stageWidth - bounds.width * _container.scaleX) / 2 - bounds.x * _container.scaleX;
			_container.y = (stage.stage.stageHeight - bounds.height * _container.scaleY) / 2 - bounds.y * _container.scaleY;
			
			_steps = recordCanvas.steps;
			addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		protected function frameHandler(event:Event = null):void
		{
			if (_index >= _steps.length)
			{
				_indicator.text = _answer || "COMPLETE";
				removeEventListener(Event.ENTER_FRAME, arguments.callee);
				trace(_answer);
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