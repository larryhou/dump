package
{
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 3:05:12 AM
	 */
	public class TestMain extends Sprite
	{
		private var _canvas:Graphics;
		
		/**
		 * 构造函数
		 * create a [TestMain] object
		 */
		public function TestMain()
		{
			var shape:Shape = new Shape();
			shape.x = 300; shape.y = 400;
			shape.scaleX = shape.scaleY = 10;
			addChild(shape);
			
			_canvas = shape.graphics;
			_canvas.lineStyle(1, 0xFF0000);
			_canvas.lineTo(10, 0);
			
			_canvas.lineStyle(2);
			_canvas.lineTo(10, 10);
			
		}		
		
	}
}