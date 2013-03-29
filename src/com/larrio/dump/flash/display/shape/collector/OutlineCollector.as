package com.larrio.dump.flash.display.shape.collector
{
	import com.larrio.dump.flash.display.shape.canvas.ICanvas;
	import com.larrio.dump.model.shape.CurvedEdgeRecord;
	import com.larrio.dump.model.shape.LineStyle;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.model.shape.ShapeWithStyle;
	import com.larrio.dump.model.shape.StraightEdgeRecord;
	import com.larrio.dump.model.shape.StyleChangeRecord;
	
	/**
	 * 只收集线条样式
	 * @author larryhou
	 * @createTime Mar 29, 2013 2:04:10 PM
	 */
	public class OutlineCollector extends AbstractCollector
	{
		private var _styles:Vector.<LineStyle>;
		
		private var _lineStyle:uint;
		
		/**
		 * 构造函数
		 * create a [OutlineCollector] object
		 */
		public function OutlineCollector(shape:Shape = null)
		{
			super(shape);
		}
		
		override public function load(shape:Shape):void
		{
			super.load(shape);
			
			if (_shape is ShapeWithStyle)
			{
				_styles = (_shape as ShapeWithStyle).lineStyles.styles;
			}
		}
		
		override public function drawVectorOn(canvas:ICanvas):void
		{
			super.drawVectorOn(canvas);
		}
		
		override protected function changeStyle(record:StyleChangeRecord):void
		{
			if (record.stateMoveTo)
			{
				_position.x = record.moveToX / TWIPS_PER_PIXEL;
				_position.y = record.moveToY / TWIPS_PER_PIXEL;
				
				_canvas.moveTo(_position.x, _position.y);
			}
			
			if (record.stateNewStyles)
			{
				_styles = record.lineStyles.styles;
			}
			
			if (record.stateLineStyle)
			{
				if (record.lineStyle)
				{
					changeLineStyle(_styles[record.lineStyle - 1]);
				}
				else
				{
					_canvas.lineStyle(NaN);
				}
			}
		}
		
		override protected function drawStraightEdge(recorder:StraightEdgeRecord):void
		{
			_position.x += recorder.deltaX / TWIPS_PER_PIXEL;
			_position.y += recorder.deltaY / TWIPS_PER_PIXEL;
			
			_canvas.lineTo(_position.x, _position.y);
		}
		
		override protected function drawCurvedEdge(record:CurvedEdgeRecord):void
		{
			var ctrlX:Number = _position.x += record.deltaControlX / TWIPS_PER_PIXEL;
			var ctrlY:Number = _position.y += record.deltaControlY / TWIPS_PER_PIXEL;
			
			var anchorX:Number = _position.x += record.deltaAnchorX / TWIPS_PER_PIXEL;
			var anchorY:Number = _position.y += record.deltaAnchorY / TWIPS_PER_PIXEL;
			
			_canvas.curveTo(ctrlX, ctrlY, anchorX, anchorY);
		}
	}
}