package com.larrio.dump.flash.display.shape.collector
{
	import com.larrio.dump.flash.display.shape.canvas.ICanvas;
	import com.larrio.dump.model.shape.CurvedEdgeShapeRecord;
	import com.larrio.dump.model.shape.FillStyle;
	import com.larrio.dump.model.shape.LineStyle;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.model.shape.ShapeRecord;
	import com.larrio.dump.model.shape.ShapeRecordType;
	import com.larrio.dump.model.shape.ShapeWithStyle;
	import com.larrio.dump.model.shape.StraightEdgeShapeRecord;
	import com.larrio.dump.model.shape.StyleChangeShapeRecord;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 矢量图收集器
	 * @author doudou
	 * @createTime Mar 27, 2013 11:41:12 PM
	 */
	public class VectorCollector extends ShapeCollector
	{
		private var _fillEdgeMap:Dictionary;
		private var _lineEdgeMap:Dictionary;
		
		private var _fillStyle0:uint;
		private var _fillStyle1:uint;
		private var _fillStyleOffset:int;
		private var _lineStyleOffset:int;
		
		private var _lineStyle:uint;
		
		private var _lineStyles:Vector.<LineStyle>;
		private var _fillStyles:Vector.<FillStyle>;
		
		private var _parts:Vector.<ShapeEdge>;
		private var _commitCount:uint;
		
		/**
		 * 构造函数
		 * create a [VectorCollector] object
		 */
		public function VectorCollector(shape:Shape = null)
		{
			super(shape);
		}
		
		override public function load(shape:Shape):void
		{
			super.load(shape);
			
			if (_shape is ShapeWithStyle)
			{
				_lineStyles = (_shape as ShapeWithStyle).lineStyles.styles;
				_fillStyles = (_shape as ShapeWithStyle).fillStyles.styles;
			}
			
			_fillEdgeMap = new Dictionary(true);
			_lineEdgeMap = new Dictionary(true);
			_parts = new Vector.<ShapeEdge>();
		}
		
		/**
		 * 在画板上绘制矢量数据 
		 * @param canvas	矢量画板
		 */		
		override public function drawVectorOn(canvas:ICanvas):void
		{
			_canvas = canvas;
			_position = new Point(0, 0);
			
			var records:Vector.<ShapeRecord> = _shape.records;
			for (var i:int = 0, length:uint = records.length; i < length; i++)
			{
				switch (records[i].type)
				{
					case ShapeRecordType.STLYE_CHANGE_SHAPE_RECORD:
					{
						processShapeStyle(records[i] as StyleChangeShapeRecord);
						break;
					}
						
					case ShapeRecordType.STRAIGHT_EDGE_SHAPE_RECORD:
					{
						processStraightEdge(records[i] as StraightEdgeShapeRecord);
						break;
					}
						
					case ShapeRecordType.CURVED_EDGE_SHAPE_RECORD:
					{
						processCurvedEdge(records[i] as CurvedEdgeShapeRecord);
						break;
					}
						
					case ShapeRecordType.END_SHAPE_RECORD:
					{
						processShapeParts(_parts, _lineStyle, _fillStyle0, _fillStyle1);
						commit();
						break;
					}
				}
			}	
		}
		
		/**
		 * 切换线条、填充样式
		 */		
		override protected function processShapeStyle(record:StyleChangeShapeRecord):void
		{
			if (record.stateMoveTo)
			{
				_position.x = record.moveToX / TWIPS_PER_PIXEL;
				_position.y = record.moveToY / TWIPS_PER_PIXEL;
			}
			
			if (record.stateLineStyle || record.stateFillStyle0 || record.stateFillStyle1)
			{
				processShapeParts(_parts, _lineStyle, _fillStyle0, _fillStyle1);
				_parts = new Vector.<ShapeEdge>();
			}
			
			if (record.stateNewStyles)
			{
				_lineStyleOffset = _lineStyles.length;
				_fillStyleOffset = _fillStyles.length;
				_lineStyles = _lineStyles.concat(record.lineStyles.styles);
				_fillStyles = _fillStyles.concat(record.fillStyles.styles);
			}
			
			if (record.stateLineStyle  && record.lineStyle  == 0 &&
			    record.stateFillStyle0 && record.fillStyle0 == 0 &&
			    record.stateFillStyle1 && record.fillStyle1 == 0)
			{
				commit();
				
				_lineStyle = 0;
				_lineEdgeMap = new Dictionary(true);
				_fillEdgeMap = new Dictionary(true);
				_fillStyle0 = 0;
				_fillStyle1 = 0;
			}
			else
			{
				if (record.stateLineStyle)
				{
					_lineStyle = record.lineStyle;
					if (record.lineStyle > 0) _lineStyle += _lineStyleOffset;
				}
				
				if (record.stateFillStyle0)
				{
					_fillStyle0 = record.fillStyle0;
					if (_fillStyle0 > 0) _fillStyle0 += _fillStyleOffset;
				}
				
				if (record.stateFillStyle1)
				{
					_fillStyle1 = record.fillStyle1;
					if (_fillStyle1 > 0) _fillStyle1 += _fillStyleOffset;
				}
			}			
		}
		
		private function processShapeParts(parts:Vector.<ShapeEdge>, lineStyle:int, fillStyle0:int, fillStyle1:int):void
		{
			var i:int;
			var edge:ShapeEdge;
			if (fillStyle0 != 0)
			{
				if (!_fillEdgeMap[fillStyle0]) _fillEdgeMap[fillStyle0] = new Vector.<ShapeEdge>();
				for (i = parts.length - 1; i >= 0; i--)
				{
					edge = parts[i].reverse();
					edge.fillStyle = fillStyle0;
					
					_fillEdgeMap[fillStyle0].push(edge);
				}
			}
			
			if (fillStyle1 != 0)
			{
				if (!_fillEdgeMap[fillStyle1]) _fillEdgeMap[fillStyle1] = new Vector.<ShapeEdge>();
				for (i = 0; i < parts.length; i++)
				{
					edge = parts[i];
					edge.fillStyle = fillStyle1;
					
					_fillEdgeMap[fillStyle1].push(edge);
				}
			}
			
			if (lineStyle != 0)
			{
				if (!_lineEdgeMap[lineStyle]) _lineEdgeMap[lineStyle] = new Vector.<ShapeEdge>();
				for (i = 0; i < parts.length; i++)
				{
					parts[i].lineStyle = lineStyle;
					_lineEdgeMap[lineStyle].push(parts[i]);
				}
			}
		}
		
		/**
		 * 处理直线
		 */		
		override protected function processStraightEdge(record:StraightEdgeShapeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(false);
			edge.x1 = trim(_position.x);
			edge.y1 = trim(_position.y);
			
			edge.x2 = trim(_position.x += record.deltaX / TWIPS_PER_PIXEL);
			edge.y2 = trim(_position.y += record.deltaY / TWIPS_PER_PIXEL);
			
			_parts.push(edge);
		}
		
		/**
		 * 处理二阶贝塞尔曲线
		 */		
		override protected function processCurvedEdge(record:CurvedEdgeShapeRecord):void
		{
			var edge:ShapeEdge = new ShapeEdge(true);
			edge.x1 = trim(_position.x);
			edge.y1 = trim(_position.y);
			
			edge.ctrX = trim(_position.x += record.deltaControlX / TWIPS_PER_PIXEL);
			edge.ctrY = trim(_position.y += record.deltaControlY / TWIPS_PER_PIXEL);
			
			edge.x2 = trim(_position.x += record.deltaAnchorX / TWIPS_PER_PIXEL);
			edge.y2 = trim(_position.y += record.deltaAnchorY / TWIPS_PER_PIXEL);
			
			_parts.push(edge);
		}
		
		private function trim(value:Number):Number
		{
			return Math.round(value * 10000) / 10000;
		}
		
		private function joinEdgesToPath(edgeMap:Dictionary):void
		{
			for (var styleIndex:* in edgeMap)
			{
				var parts:Vector.<ShapeEdge> = edgeMap[styleIndex];
				if (parts && parts.length)
				{
					var edge:ShapeEdge;
					var path:Vector.<ShapeEdge> = Vector.<ShapeEdge>([]);
					
					var prevEdge:ShapeEdge, index:int;
					var map:Dictionary = createEdgeKeyMap(Vector.<ShapeEdge>(parts));
					while (parts.length > 0)
					{
						index = 0;
						while (index < parts.length)
						{
							if (prevEdge == null || (parts[index].x1 - prevEdge.x2 == 0 && parts[index].y1 - prevEdge.y2 == 0))
							{
								edge = parts.splice(index, 1)[0];
								path.push(edge);
								
								removeEdgeFromKeyMap(edge, map);
								prevEdge = edge;
							}
							else
							{
								var key:String = prevEdge.x2 + "_" + prevEdge.y2;
								edge = map[key]? map[key][0] : null;
								if (edge)
								{
									index = parts.indexOf(edge);
								}
								else
								{
									prevEdge = null;
									index = 0;
								}
							}
						}
					}
					
					edgeMap[styleIndex] = path;
				}
			}
			
		}
		
		private function createEdgeKeyMap(path:Vector.<ShapeEdge>):Dictionary
		{
			var map:Dictionary = new Dictionary(true);
			for (var i:int = 0; i < path.length; i++)
			{
				var key:String = getEdgeKey(path[i]);
				if (!map[key]) map[key] = new Vector.<ShapeEdge>();
				map[key].push(path[i]);
			}
			
			return map;
		}
		
		private function removeEdgeFromKeyMap(edge:ShapeEdge, map:Dictionary):void
		{
			if (!edge) return;
			
			var key:String = getEdgeKey(edge);
			if (map[key])
			{
				var list:Vector.<ShapeEdge> = map[key];
				if (list.length > 1)
				{
					var index:int = list.indexOf(edge);
					if (index >= 0)
					{
						list.splice(index, 1);
					}
				}
				else
				{
					delete map[key];
				}
			}
		}
		
		private function getEdgeKey(edge:ShapeEdge):String
		{
			return edge.x1 + "_" + edge.y1;
		}
		
		private function stripShapePath(edgeMap:Dictionary):Vector.<ShapeEdge>
		{
			var indices:Array = [];
			for (var styleIndex:* in edgeMap)
			{
				indices.push(styleIndex);
			}
			
			indices.sort(Array.NUMERIC);
			
			var path:Vector.<ShapeEdge> = new Vector.<ShapeEdge>();
			for (var i:int = 0; i < indices.length; i++)
			{
				styleIndex = indices[i];
				path = path.concat(edgeMap[styleIndex]);
			}
			
			return path;
		}
		
		private function commit():void
		{
			_commitCount++;
			
			joinEdgesToPath(_fillEdgeMap);
			joinEdgesToPath(_lineEdgeMap);
			
			trace("// Fills " + _commitCount);
			var path:Vector.<ShapeEdge> = stripShapePath(_fillEdgeMap);
			
			_canvas.lineStyle(NaN);
			
			var index:uint = uint.MAX_VALUE;
			var pos:Point = new Point(Number.MAX_VALUE, Number.MAX_VALUE);
			var edge:ShapeEdge, prev:ShapeEdge;
			for (var n:int = 0; n < path.length; n++)
			{
				edge = path[n];
				if (index != edge.fillStyle)
				{
					if (index != uint.MAX_VALUE)
					{
						_canvas.endFill();
					}
					
					index = edge.fillStyle;
					pos.setTo(Number.MAX_VALUE, Number.MAX_VALUE);
					
					changeFillStyle(_fillStyles[index - 1]);
				}
				
				if (edge.x1 != pos.x || edge.y1 != pos.y)
				{
					_canvas.moveTo(edge.x1, edge.y1);
				}
				
				if (edge.curved)
				{
					_canvas.curveTo(edge.ctrX, edge.ctrY, edge.x2, edge.y2);
				}
				else
				{
					_canvas.lineTo(edge.x2, edge.y2);
				}
				
				pos.setTo(edge.x2, edge.y2);
			}
			
			if (index != uint.MAX_VALUE)
			{
				_canvas.endFill();
			}
			
			strokeOnPath(stripShapePath(_lineEdgeMap));
		}
		
		private function strokeOnPath(path:Vector.<ShapeEdge>):void
		{
			if (path.length == 0) return;
			
			trace("// Lines " + _commitCount);
			
			var styleIndex:uint = uint.MAX_VALUE;
			var pos:Point = new Point(Number.MAX_VALUE, Number.MAX_VALUE);
			
			var edge:ShapeEdge;
			for (var n:int = 0; n < path.length; n++)
			{
				edge = path[n];
				if (styleIndex != edge.lineStyle)
				{
					styleIndex = edge.lineStyle;
					pos.setTo(Number.MAX_VALUE, Number.MAX_VALUE);
					changeLineStyle(_lineStyles[styleIndex - 1]);
				}
				
				if (edge.x1 != pos.x || edge.y1 != pos.y)
				{
					_canvas.moveTo(edge.x1, edge.y1);
				}
				
				if (edge.curved)
				{
					_canvas.curveTo(edge.ctrX, edge.ctrY, edge.x2, edge.y2);
				}
				else
				{
					_canvas.lineTo(edge.x2, edge.y2);
				}
				
				pos.setTo(edge.x2, edge.y2);
			}
		}		
	}
}

class ShapeEdge
{
	public var x1:Number;
	public var y1:Number;
	
	public var x2:Number;
	public var y2:Number;
	
	public var ctrX:Number;
	public var ctrY:Number;
	
	public var lineStyle:uint;
	public var fillStyle:uint;
	
	public var curved:Boolean;
	
	public function ShapeEdge(curved:Boolean)
	{
		this.curved = curved;
	}
	
	public function reverse():ShapeEdge
	{
		var edge:ShapeEdge = new ShapeEdge(this.curved);
		edge.x1 = this.x2;
		edge.y1 = this.y2;
		
		edge.x2 = this.x1;
		edge.y2 = this.y1;
		
		edge.ctrX = this.ctrX;
		edge.ctrY = this.ctrY;
		
		return edge;
	}
}