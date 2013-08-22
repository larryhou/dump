package demos
{
	import flash.display.Sprite;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 笔触节点
	 * @author larryhou
	 * @createTime Apr 1, 2013 11:10:33 AM
	 */
	public class JointMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [JointMain] object
		 */
		public function JointMain()
		{
			graphics.lineStyle(30, 0xFF0000, 0.3);
			graphics.moveTo(200, 200);
			graphics.lineTo(600, 200);
			//graphics.moveTo(600, 200);
			graphics.lineTo(600, 600);
			
			graphics.lineStyle(NaN);
			graphics.beginFill(0xFF00FF, 1);
			graphics.moveTo(200, 250);
			graphics.lineTo(550, 250);
			//graphics.moveTo(550, 250);
			graphics.lineTo(550, 550);
			//graphics.moveTo(550, 550);
			graphics.lineTo(200, 550);
			//graphics.moveTo(200, 550);
			graphics.lineTo(200, 250);
			graphics.endFill();
		}
	}
}