package com.larrio.math
{
	import flash.geom.Point;
	
	/**
	 * 贝塞尔工具
	 * @author larryhou
	 * @createTime 2015/1/30 14:13
	 * 
	 * 绘制贝赛尔曲线点
	 * @param	list	控制点
	 * @param	ratio	贝赛尔曲线比例
	 * @return	返回ratio比例对应贝赛尔曲线上的点坐标
	 * list.length代表贝赛尔曲线的阶数，一般二阶即可满足需要，二阶需要三个点
	 */
	public function bezier(list:Array/*list.length >= 2*/, ratio:Number/*0 =< ratio <= 1*/):Point
	{
		var result:Point;
		if (list.length > 1)
		{
			var ctrl:Object;
			
			var length:int = list.length;
			for (var i:int = 0; i < length - 1; i++)
			{
				ctrl = list[i];
				
				list[i] = { x:0, y:0 };
				list[i].x = (1 - ratio) * ctrl.x + ratio * list[i + 1].x;
				list[i].y = (1 - ratio) * ctrl.y + ratio * list[i + 1].y;
			}
			
			list.pop();
			result = bezier(list, ratio);
		}
		else
		{
			result = new Point(list[0].x, list[0].y);
		}
		
		return result;
	}
}
