package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.display.Graphics;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 29, 2012 12:20:03 PM
	 */
	public class ShapeWithStyle extends Shape
	{
		private var _fillStyles:FillStyleArray;
		private var _lineStyles:LineStyleArray;
		
		/**
		 * 构造函数
		 * create a [ShapeWithStyle] object
		 */
		public function ShapeWithStyle(shape:uint)
		{
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			decoder.byteAlign();
			
			_fillStyles = new FillStyleArray(_shape);
			_fillStyles.decode(decoder);
			
			_lineStyles = new LineStyleArray(_shape);
			_lineStyles.decode(decoder);
			
			super.decode(decoder);
			
			assertTrue(decoder.bytesAvailable == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.flush();
			
			_fillStyles.encode(encoder);
			_lineStyles.encode(encoder);
			
			super.encode(encoder);
		}
		
		/**
		 * 把数据绘制成图形 
		 * @param canvas	graphics对象
		 */		
		override public function draw(canvas:Graphics):void
		{
			var fstyles:FillStyleArray = _fillStyles;
			var lstyles:LineStyleArray = _lineStyles;
			
			var curve:CurvedEdgeRecord;
			var line:StraightEdgeRecord;
			var style:StyleChangeRecord;
			
			var locX:int, locY:int;
			
			var length:uint = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				if (_records[i] is StyleChangeRecord)
				{
					style = _records[i] as StyleChangeRecord;
					if (style.stateNewStyles)
					{
						fstyles = style.fillStyles;
						lstyles = style.lineStyles;
					}
					
					if (style.stateLineStyle && style.lineStyle)
					{
						lstyles.styles[style.lineStyle - 1].changeStyle(canvas);
					}
					
					if (style.stateFillStyle0 && style.fillStyle0)
					{
						fstyles.styles[style.fillStyle0 - 1].changeStyle(canvas);
					}
					
					if (!style.fillStyle0 && style.fillStyle1)
					{
						fstyles.styles[style.fillStyle1 - 1].changeStyle(canvas);
					}
					
					if (style.stateMoveTo)
					{
						canvas.moveTo(locX = style.moveToX, locY = style.moveToY);
					}
				}
				else
				if (_records[i] is CurvedEdgeRecord)
				{
					curve = _records[i] as CurvedEdgeRecord;
					var ctrlX:int = locX += curve.deltaControlX;
					var ctrlY:int = locY += curve.deltaControlY;
					
					locX += curve.deltaAnchorX;
					locY += curve.deltaAnchorY;
					canvas.curveTo(ctrlX, ctrlY, locX, locY);
				}
				else
				{
					line = _records[i] as StraightEdgeRecord;
					canvas.lineTo(locX += line.deltaX, locY += line.deltaY);
				}
			}
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<ShapeWithStyle/>");
			result.appendChild(new XML(_fillStyles.toString()));
			result.appendChild(new XML(_lineStyles.toString()));
			
			var length:int = _records.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_records[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Array of fill styles.
		 */		
		public function get fillStyles():FillStyleArray { return _fillStyles; }

		/**
		 * Array of line styles.
		 */		
		public function get lineStyles():LineStyleArray { return _lineStyles; }

	}
}