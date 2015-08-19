package demos
{
	import com.greensock.easing.Sine;
	import com.larrio.math.fixed;
	import com.larrio.math.unfixed;
	import com.larrio.math.unfloat;
	import com.larrio.math.unsign;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 笔触节点
	 * @author larryhou
	 * @createTime Apr 1, 2013 11:10:33 AM
	 */
	public class MathMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [JointMain] object
		 */
		public function MathMain()
		{
			testFixedFloat();
		}
		
		private function testFixedFloat():void
		{
			var signs:Vector.<int> = Vector.<int>([1, -1]);
			
			var data:ByteArray = new ByteArray();
			for (var i:int = 0; i < 10; i++)
			{
				var value:Number = 10000 * Math.random() * signs[signs.length * Math.random() >> 0];
				var binary:uint = unfixed(value, 16, 16);
				trace(fixed(binary, 16, 16), value);
			}
		}
	}
}