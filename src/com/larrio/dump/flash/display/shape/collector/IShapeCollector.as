package com.larrio.dump.flash.display.shape.collector
{
	import com.larrio.dump.flash.display.shape.canvas.ICanvas;
	
	/**
	 * 矢量图收集器接口
	 * @author larryhou
	 * @createTime Mar 28, 2013 7:58:45 PM
	 */
	public interface IShapeCollector
	{
		function drawVectorOn(canvas:ICanvas):void;
	}
}