package demos.compare
{
	import flash.display.LineScaleMode;
	import flash.display.Sprite;

	[SWF(width="1024", height="768")]
	/**
	 * 
	 * @author larryhou
	 * @createTime Sep 29, 2015 3:10:48 PM
	 */
	public class LineScaleModeMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [LineScaleModeMain] object
		 */
		public function LineScaleModeMain()
		{			
			var params:Array = [];
			params.push(LineScaleMode.HORIZONTAL);
			params.push(LineScaleMode.VERTICAL);
			params.push(LineScaleMode.NORMAL);
			params.push(LineScaleMode.NONE);
			
			var position:Number = 0;
			
			const SCALE:Number = 4;
			for (var i:int = 1; i <= 4; i++)
			{
				var sx:Number = Math.ceil(i / 2);
				var sy:Number = ((i - 1) % 2) + 1;
				if (sx > 1) sx = SCALE;
				if (sy > 1) sy = SCALE;
				var item:Circle = new Circle(48, 0xFF0000, params[3]);
				item.scaleX = sx;
				item.scaleY = sy;
				item.x = position + item.width / 2 + 10;
				item.y = stage.stageHeight / 2;
				position = item.x + item.width / 2;
				addChild(item);
			}
		}
	}
}
import flash.display.Shape;

class Circle extends Shape
{
	public function Circle(radius:Number, color:uint, mode:String)
	{
		graphics.lineStyle(1, color, 1, false, mode, null, null, 3);
		graphics.drawCircle(0, 0, radius);
	}
}