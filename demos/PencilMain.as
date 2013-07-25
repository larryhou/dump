package   
{
	import com.greensock.TweenLite;
	import com.larrio.dump.SWFile;
	import com.larrio.dump.flash.display.font.GlyphCollector;
	import com.larrio.dump.flash.display.shape.canvas.SimpleCanvas;
	import com.larrio.dump.flash.display.shape.collector.OutlineCollector;
	import com.larrio.dump.tags.DefineFont2Tag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.math.bezier;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	[SWF(frameRate="60", width="600", height="400")]
	
	
	/**
	 * 
	 * @author doudou
	 * @createTime Mar 30, 2013 4:38:34 PM
	 */
	public class PencilMain extends Sprite
	{
		private const LINE_THICKNESS:uint = 6;
		
		[Embed(source="../libs/fonts.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		private var _steps:Array;
		private var _pencil:Graphics;
		
		private var _index:uint;
		private var _position:Point;
		
		private var _alias:MovieClip;
		private var _container:Sprite;
		
		private var _glyph:Shape;
		
		/**
		 * 构造函数
		 * create a [PencilMain] object
		 */
		public function PencilMain()
		{
			trace(new FileByteArray is ByteArray);
			
			var collector:GlyphCollector;
			var list:Vector.<GlyphCollector> = new Vector.<GlyphCollector>;
			
			var swf:SWFile = new SWFile(new FileByteArray());
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag is DefineFont2Tag)
				{
					list.push(new GlyphCollector(tag as DefineFont2Tag));
				}
			}
			
			for each(collector in list)
			{
//				if (collector.name == "Wawati SC Regular") break;
//				if (collector.name == "Yuanti SC Regular") break;
				if (collector.name == "Xingkai SC Bold") break;
//				if (collector.name == "Songti SC Bold") break;
			}
	
//			collector = list[0];
			
			var chars:String = "火影";
			var canvas:SimpleCanvas = new SimpleCanvas();
			
			var outline:OutlineCollector = new OutlineCollector();
			
			for (var i:int = 0; i < chars.length; i++)
			{
				outline.load(collector.getGlyphByChar(chars.charAt(i)));
				outline.drawVectorOn(canvas);
				
				canvas.steps.push(null);
			}
			
			_steps = canvas.steps;
			
			_container = new Sprite();
			_container.y = 300;
			_container.scaleX = _container.scaleY = 1 / 5;
			addChild(_container);
			
			_glyph = new Shape();
			_container.addChild(_glyph);
			
			_pencil = _glyph.graphics;
			_pencil.lineStyle(LINE_THICKNESS, 0xFF00FF);
			
			_position = new Point();
			_container.addChild(_alias = new (getDefinitionByName("Pencil") as Class)());
			_alias.scaleX = _alias.scaleY = 4;
			
			forward();
		}
		
		private function forward():void
		{
			if (_index >= _steps.length)
			{
				_alias.visible = false;
				removeEventListener(Event.ENTER_FRAME, arguments.callee);
				return;
			}
			
			var step:Object = _steps[_index++];
			if (!step)
			{
				var rect:Rectangle = _glyph.getBounds(_container);
				
				_container.addChild(_glyph = new Shape());
				_container.setChildIndex(_alias, _container.numChildren - 1);
				_glyph.x = rect.x + rect.width + 20;
				
				_pencil = _glyph.graphics;
				_pencil.lineStyle(LINE_THICKNESS, 0xFF00FF);
				
				forward();
				return;
			}
			
			var params:Array = step.params;
			
			if (step.method == "moveTo")
			{
				_pencil.moveTo.apply(null, params);
				_position.x = params[0];
				_position.y = params[1];
				
				_alias.x = _position.x + _glyph.x;
				_alias.y = _position.y + _glyph.y;
				
				forward();
			}
			else
			{
				var list:Array = [_position.clone()];
				while (params.length)
				{
					list.push(new Point(params.shift(), params.shift()));
				}
				
				var dst:Point = list[list.length - 1];
				
				var pos:Point;
				var data:Object = {t: 0};
				TweenLite.to(data, 0.15, {t: 1, onUpdate:function ():void
				{
					pos = bezier(list.concat(), data.t);
					
					_alias.x = pos.x + _glyph.x;
					_alias.y = pos.y + _glyph.y;
					_pencil.lineTo(pos.x, pos.y);
				},
				onComplete:function():void
				{
					_position.x = dst.x;
					_position.y = dst.y;
					
					_alias.x = _position.x + _glyph.x;
					_alias.y = _position.y + _glyph.y;
					
					forward();
				}
				});
			}
		}
		
		protected function frameHandler(event:Event):void
		{
			if (_index >= _steps.length)
			{
				removeEventListener(Event.ENTER_FRAME, arguments.callee);
				return;
			}
			
			var step:Object = _steps[_index++];
			
			(_pencil[step.method] as Function).apply(null, step.params);
			
			if (step.method == "moveTo")
			{
				frameHandler(null);
			}
		}
	}
}