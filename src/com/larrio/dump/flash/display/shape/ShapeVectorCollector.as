package com.larrio.dump.flash.display.shape
{
	import com.larrio.dump.model.shape.CurvedEdgeRecord;
	import com.larrio.dump.model.shape.FillStyle;
	import com.larrio.dump.model.shape.LineStyle;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.model.shape.ShapeRecord;
	import com.larrio.dump.model.shape.ShapeWithStyle;
	import com.larrio.dump.model.shape.StraightEdgeRecord;
	import com.larrio.dump.model.shape.StyleChangeRecord;
	
	import flash.utils.Dictionary;
	
	/**
	 * Shape矢量数据收集器
	 * @author larryhou
	 * @createTime Mar 26, 2013 12:17:55 PM
	 */
	public class ShapeVectorCollector
	{
		private var _shape:Shape;
		private var _canvas:ICanvas;
		
		private var _fstyles:Vector.<FillStyle>;
		private var _lstyles:Vector.<LineStyle>;
		
		private var _records:Vector.<ShapeRecord>;
		
		private var _lineStyle:Object;
		private var _dict:Dictionary;
		
		private var _f0:uint;
		private var _f1:uint;
		private var _style:StyleComponent;
		
		/**
		 * 构造函数
		 * create a [ShapeVectorCollector] object
		 * @param shape	Shape矢量数据描述对象
		 */		
		public function ShapeVectorCollector(shape:Shape)
		{
			_shape = shape;
			
			if (_shape is ShapeWithStyle)
			{
				_fstyles = (_shape as ShapeWithStyle).fillStyles.styles;
				_lstyles = (_shape as ShapeWithStyle).lineStyles.styles;
			}
			
			_records = _shape.records;
			_style = new StyleComponent(_fstyles, _lstyles);
			
			_lineStyle = {};
		}
		
		/**
		 * 在canvas上绘制矢量数据 
		 * @param canvas	实现ICanvas接口的对象
		 */		
		public function drawVectorOn(canvas:ICanvas):void
		{
			_canvas = canvas;
			_dict = new Dictionary();
			
			for (var i:int = 0, length:uint = _records.length; i < length; i++)
			{
				if (_records[i] is CurvedEdgeRecord)
				{
					
				}
				else
				if (_records[i] is StraightEdgeRecord)
				{
					
				}
				else
				if (_records[i] is StyleChangeRecord)
				{
					
				}
				else
				{
					_canvas.endFill();
				}
			}
		}
		
		/**
		 * 根据坐标生成唯一索引 
		 */		
		private function createKey(x:Number, y:Number):String
		{
			return x + "_" + y;
		}
	}
}

import com.larrio.dump.model.shape.FillStyle;
import com.larrio.dump.model.shape.LineStyle;

import flash.utils.Dictionary;

// 同样式色块
class StyleComponent
{
	private static var _sequence:uint;
	
	public var id:uint;
	public var fillStyles:Vector.<FillStyle>;
	public var lineStyles:Vector.<LineStyle>;
	
	public var map:Dictionary;
	
	public function StyleComponent(fillStyles:Vector.<FillStyle>, lineStyles:Vector.<LineStyle>)
	{
		this.fillStyles = fillStyles; this.lineStyles = lineStyles;
		
		this.id = ++_sequence; 
		this.map = new Dictionary(false);
	}	
}

// 图形边界线条
class ShapeEdge
{	
	/**
	 * 线条起点坐标 
	 */	
	public var x:Number;
	public var y:Number;
	
	/**
	 * 贝塞尔曲线控制点坐标 
	 */	
	public var ctrlX:Number;
	public var ctrlY:Number;
	
	/**
	 * 线条终点坐标
	 */	
	public var tx:Number;
	public var ty:Number;
	
	public var curve:Boolean;
	
	public function ShapeEdge(curve:Boolean)
	{
		this.curve = curve;
		this.x = this.y = this.ctrlX = this.ctrlY = this.tx = this.ty = 0;
	}
}