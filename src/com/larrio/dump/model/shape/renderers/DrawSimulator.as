package com.larrio.dump.model.shape.renderers
{
	import com.greensock.TweenLite;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.math.bezier;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 整个动画完成时派发 
	 */	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Mar 25, 2013 1:54:16 PM
	 */
	public class DrawSimulator extends EventDispatcher
	{
		private var _renderer:ShapeRenderer;
		
		private var _canvas:Graphics;
		private var _shape:com.larrio.dump.model.shape.Shape;
		
		private var _dict:Dictionary;
		
		private var _running:Boolean;
		
		private var _index:uint;
		private var _datalist:Array;
		
		private var _position:Point;
		
		/**
		 * 构造函数
		 * create a [DrawSimulator] object
		 */
		public function DrawSimulator(canvas:Graphics, shape:com.larrio.dump.model.shape.Shape, dict:Dictionary)
		{
			_canvas = canvas; _dict = dict; _shape = shape;
		}
		
		/**
		 * 启动模拟动画
		 */		
		public function start():void
		{
			if (!_running)
			{
				_running = true;
				_renderer = ShapeRenderer.render(new flash.display.Shape().graphics, _shape, _dict, execute);
			}
		}
		
		private function execute():void
		{
			_position = new Point();
			_datalist = _renderer.data;
			
			// 清空临时对象
			_renderer.canvas.clear();
			
			forward(0);
		}
		
		private function forward(step:uint):void
		{
			_index = step;
			if (_index >= _datalist.length)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			var params:Array, flag:Boolean;
			var item:Object, method:String;
			while (_index < _datalist.length)
			{
				item = _datalist[_index];
				for (method in item) break;
				
				params = item[method] as Array;
				
				flag = false;
				switch (method)
				{					
					case "lineTo":
					{
						lineTo(params);
						break;
					}
						
					case "curveTo":
					{
						curveTo(params);
						break;
					}
						
					default:
					{
						flag = true;
						if (method == "moveTo")
						{
							_position.x = params[0];
							_position.y = params[1];
							trace("moveTo:" + _position);
						}
						
						(_canvas[method] as Function).apply(null, params);
						break;
					}
						
				}
				
				if (!flag) break;
				
				_index++;
			}
		}
		
		/**
		 * 绘制二阶被赛尔曲线
		 * @param params	一个控制点一个目标点：四个元素
		 */		
		private function curveTo(params:Array):void
		{
			var list:Array = [_position.clone()];
			list.push(new Point(params[0], params[1]), new Point(params[2], params[3]));
			
			var result:Array = [];
			
			const MAX_NUM:uint = 100;
			for (var i:int = 0; i <= MAX_NUM; i++) result.push(bezier(list, i / MAX_NUM));
			
			var obj:Object = {value: 0, index: 0};
			TweenLite.to(obj, 0.5, {value: result.length - 1, onUpdate:function():void
			{
				var pos:Point;
				var num:uint = obj.value >> 0; 
				if (num > obj.index)
				{
					pos = result[obj.index = num];
					
					_canvas.lineTo(_position.x = pos.x, _position.y = pos.y);
				}
			}, 
			onComplete:function():void
			{
				trace("curveTo:" + _index);
				forward(_index + 1);
			}});
		}
		
		/**
		 * 绘制直线 
		 * @param params	一个目标点：两个元素
		 */		
		private function lineTo(params:Array):void
		{
			var target:Point = new Point(params[0], params[1]);
			var distance:Number = Point.distance(_position, target);
			
			var duration:Number = distance / 1000;
			TweenLite.to(_position, 0.5, {x: target.x, y:target.y, onUpdate:function():void
			{
				_canvas.lineTo(_position.x, _position.y);
			}, 
			onComplete:function():void
			{
				trace("lineTo:" + _index);
				forward(_index + 1);
			}});
		}
	}
}