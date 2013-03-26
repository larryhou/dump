package com.larrio.dump.flash.display.shape
{
	import com.larrio.dump.model.shape.Shape;
	
	/**
	 * Shape矢量数据收集器
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:17:55 PM
	 */
	public class ShapeVectorCollector
	{
		private var _shape:Shape;
		private var _canvas:ICanvas;
		
		/**
		 * 构造函数
		 * create a [ShapeVectorCollector] object
		 * @param shape	Shape矢量数据描述对象
		 */		
		public function ShapeVectorCollector(shape:Shape)
		{
			_shape = shape;
		}
		
		/**
		 * 在canvas上绘制矢量数据 
		 * @param canvas	实现ICanvas接口的对象
		 */		
		public function drawVectorOn(canvas:ICanvas):void
		{
			_canvas = canvas;
		}
		
		
	}
}