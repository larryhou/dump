package com.larrio.math
{
	import flash.geom.Point;
	
	/**
	 * 贝塞尔工具
	 * @author larryhou
	 * @createTime 2012/8/21 16:24
	 * 
	 * 绘制贝赛尔曲线点
	 * @param	list	控制点
	 * @param	ratio	贝赛尔曲线比例
	 * @return	返回ratio比例对应贝赛尔曲线上的点坐标
	 * list.length代表贝赛尔曲线的阶数，一般二阶即可满足需要，二阶需要三个点
	 */
	public function bezier(list:Array/*list.length >= 2*/, ratio:Number/*0 =< ratio <= 1*/):Point
	{
		if (!list) return null;
		
		if (list.length > 1)
		{
			var pos:Point;
			var length:int = list.length;
			for (var i:int = 0; i < length - 1; i++)
			{
				pos = list[i];
				
				list[i] = new Point();
				list[i].x = (1 - ratio) * pos.x + ratio * list[i + 1].x;
				list[i].y = (1 - ratio) * pos.y + ratio * list[i + 1].y;
			}
			
			list.pop();
			return arguments.callee.apply(null, arguments);
		}
		
		return list[0];
	}
}