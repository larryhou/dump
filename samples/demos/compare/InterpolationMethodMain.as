package demos.compare
{
	import flash.display.DisplayObject;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	[SWF(width="1024", height="768")]
	/**
	 * 
	 * @author larryhou
	 * @createTime Sep 29, 2015 4:00:11 PM
	 */
	public class InterpolationMethodMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [InterpolationMethodMain] object
		 */
		public function InterpolationMethodMain()
		{
			var list:Vector.<Shape> = new Vector.<Shape>();
			list.push(new GradientRegion(InterpolationMethod.RGB));
			list.push(new GradientRegion(InterpolationMethod.LINEAR_RGB));
			
			var position:Number = 10;
			for (var i:int = 0; i < list.length; i++)
			{
				var item:DisplayObject = list[i];
				item.x = (stage.stageWidth - item.width) / 2;
				item.y = position;
				addChild(item);
				
				position += item.height + 20;
			}
		}
	}
}
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.SpreadMethod;
import flash.geom.Matrix;

class GradientRegion extends Shape
{
	public function GradientRegion(method:String)
	{
		var r_w:Number = 960;
		var r_h:Number = 200;
		var g_w:Number = 200;
		var g_h:Number = r_h;
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(g_w, g_h, 0, (r_w - g_w) / 2, 0);
		graphics.lineStyle();
		graphics.beginGradientFill(GradientType.LINEAR, [0xFF0000, 0xFFFF00, 0x00FF00], [1,1,1], [0, 0x7F, 0xFF], matrix, SpreadMethod.REFLECT, method);
		graphics.drawRect(0,0, r_w, r_h);
		graphics.endFill();
	}
}