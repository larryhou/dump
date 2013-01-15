package com.larrio.dump.model.shape.renderers
{
	import com.larrio.dump.model.colors.RGBAColor;
	import com.larrio.dump.model.shape.CurvedEdgeRecord;
	import com.larrio.dump.model.shape.FillStyle;
	import com.larrio.dump.model.shape.FocalGradient;
	import com.larrio.dump.model.shape.GradRecord;
	import com.larrio.dump.model.shape.LineStyle;
	import com.larrio.dump.model.shape.LineStyle2;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.model.shape.ShapeRecord;
	import com.larrio.dump.model.shape.ShapeWithStyle;
	import com.larrio.dump.model.shape.StraightEdgeRecord;
	import com.larrio.dump.model.shape.StyleChangeRecord;
	import com.larrio.dump.tags.DefineBitsJPEG3Tag;
	import com.larrio.dump.tags.DefineBitsLosslessTag;
	import com.larrio.dump.tags.DefineBitsTag;
	import com.larrio.math.fixed;
	
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 图形渲染器
	 * @author larryhou
	 * @createTime Jan 14, 2013 1:34:43 PM
	 */
	public class ShapeRenderer extends EventDispatcher
	{
		/**
		 * 渲染Shape图形 
		 * @param canvas	画板
		 * @param shape		图形数据
		 * @param dict		SWF素材映射表
		 * @param callback	渲染完成时的回调函数
		 * @usage 如果shape为嵌入字体glyph对象，则调用该方法前需要设置canvas的线型以及填充颜色
		 */		
		public static function render(canvas:Graphics, shape:Shape, dict:Dictionary, callback:Function = null):void
		{
			var renderer:ShapeRenderer = new ShapeRenderer(canvas, shape, dict, new larryhou());
			renderer.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				callback && callback.call();
			});
			
			renderer.render();
		}
		
		// instance members
		//********************************
		private var _canvas:Graphics;
		
		private var _dict:Dictionary;
		private var _shape:Shape;
		
		private var _fstyles:Vector.<FillStyle>;
		private var _lstyles:Vector.<LineStyle>;
		private var _records:Vector.<ShapeRecord>;
		
		private var _position:Point;
		
		private var _index:uint;
		private var _lineStyle:Object;
		
		private var _bitmaps:Dictionary;
		
		/**
		 * 构造函数
		 * create a [ShapeRenderer] object
		 * @param canvas	画板
		 * @param shape		图形数据
		 * @param dict		SWF素材映射表
		 */		
		public function ShapeRenderer(canvas:Graphics, shape:Shape, dict:Dictionary, data:larryhou)
		{
			_canvas = canvas; _shape = shape; _dict = dict;
			
			if (_shape is ShapeWithStyle)
			{
				_fstyles = (_shape as ShapeWithStyle).fillStyles.styles;
				_lstyles = (_shape as ShapeWithStyle).lineStyles.styles;
			}
			
			_records = _shape.records;
			
			_lineStyle = {};
			_position = new Point();
			
			_bitmaps = new Dictionary(true);
			
			_index = 0;
		}
		
		/**
		 * 垃圾回收
		 */		
		private function dispose():void
		{
			_dict = null;
			_canvas = null;	_shape = null;
			
			_lineStyle = null;
			_fstyles = null; _lstyles = null;
		}
		
		/**
		 * 迭代单步渲染核心 
		 * @param index	当前ShapeRecord索引
		 */		
		private function render():void
		{
			var line:StraightEdgeRecord;
			var curve:CurvedEdgeRecord;
			
			var ctrlX:int, ctrlY:int;
			var length:int = _records.length;
			
			var async:Boolean;
			while (_index < length)
			{
				if (_records[_index] is StyleChangeRecord)
				{
					async = changeStyle(_canvas, _records[_index] as StyleChangeRecord);
					if (!async) break;
				}
				else
				if (_records[_index] is CurvedEdgeRecord)
				{
					curve = _records[_index] as CurvedEdgeRecord;
					
					ctrlX = _position.x += curve.deltaControlX;
					ctrlY = _position.y += curve.deltaControlY;
					
					_position.x += curve.deltaAnchorX;
					_position.y += curve.deltaAnchorY;
					_canvas.curveTo(ctrlX, ctrlY, _position.x, _position.y);
				}
				else
				{
					line = _records[_index] as StraightEdgeRecord;
					
					_canvas.lineTo(_position.x += line.deltaX, _position.y += line.deltaY);
				}
				
				++_index;
			}
			
			if (_index >= length)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				dispose();
			}
		}
		
		/**
		 * 改变样式 
		 * @param style		样式数据
		 * @param callback	样式改变完成后回调函数
		 * 
		 */		
		private function changeStyle(canvas:Graphics, style:StyleChangeRecord):Boolean
		{
			_position.x = style.moveToX;
			_position.y = style.moveToY;
			canvas.moveTo(_position.x, _position.y);
			
			var setStyle:Function;
			if (_shape is ShapeWithStyle)
			{
				if (style.stateNewStyles)
				{
					_fstyles = style.fillStyles.styles;
					_lstyles = style.lineStyles.styles;
				}
				
				if (style.stateLineStyle && style.lineStyle)
				{
					changeLineStyle(canvas, _lstyles[style.lineStyle - 1]);
				}
				
				if (!style.stateFillStyle0 && style.fillStyle1)
				{
					return changeFillStyle(canvas, _fstyles[style.fillStyle1 - 1]);
				}
				else
				if (style.stateFillStyle0 && style.fillStyle0)
				{
					return changeFillStyle(canvas, _fstyles[style.fillStyle0 - 1]);
				}
				
			}
			
			return true;
		}
		
		/**
		 * 设置线条样式 
		 * @param stlye	样式数据
		 */		
		private function changeLineStyle(canvas:Graphics, style:LineStyle):void
		{
			_lineStyle["thickness"] = style.width / 20;
			
			var ls:LineStyle2;
			if (style is LineStyle2)
			{
				ls = style as LineStyle2;
				
				switch (ls.startCapStyle)
				{
					case 0:_lineStyle["caps"] = CapsStyle.ROUND;break;
					case 1:_lineStyle["caps"] = CapsStyle.NONE;break;
					case 2:_lineStyle["caps"] = CapsStyle.SQUARE;break;
				}
				
				switch (ls.joinStyle)
				{
					case 0:_lineStyle["joints"] = JointStyle.ROUND;break;
					case 1:_lineStyle["joints"] = JointStyle.BEVEL;break;
					case 2:_lineStyle["joints"] = JointStyle.MITER;break;
				}
				
				_lineStyle["limit"] = 3;
				if (ls.joinStyle == 2) _lineStyle["limit"] = fixed(ls.miterLimitFactor, 8, 8);
				
				switch (ls.noHScaleFlag << 1 | ls.noVScaleFlag)
				{
					case 0:_lineStyle["scale"] = LineScaleMode.NORMAL;break;
					case 1:_lineStyle["scale"] = LineScaleMode.HORIZONTAL;break;
					case 2:_lineStyle["scale"] = LineScaleMode.VERTICAL;break;
					case 3:_lineStyle["scale"] = LineScaleMode.NONE;break;
				}
				
				_lineStyle["hinting"] = Boolean(ls.pixelHintingFlag);
				
				if (ls.hasFillFlag)
				{
					changeFillStyle(canvas, ls.style, false);
				}
				else
				{
					_lineStyle["color"] = ls.color.rgb;
					_lineStyle["alpha"] = (ls.color as RGBAColor).alpha / 0xFF;
				}
				
				canvas.lineStyle(_lineStyle["thickness"], _lineStyle["color"], _lineStyle["alpha"],  _lineStyle["hinting"], _lineStyle["scale"], _lineStyle["caps"], _lineStyle["joints"], _lineStyle["limit"]);

			}
			else
			{
				if (style.color is RGBAColor)
				{
					_lineStyle["alpha"] = (style.color as RGBAColor).alpha / 0xFF;
				}
				else
				{
					_lineStyle["alpha"] = 1;
				}
				
				_lineStyle["color"] = style.color.rgb;
				
				canvas.lineStyle(_lineStyle["thickness"], _lineStyle["color"], _lineStyle["alpha"]);
			}
		}
		
		/**
		 * 更改填充样式 
		 * @param style		样式数据
		 * @param callback	设置完成后回调函数
		 */		
		private function changeFillStyle(canvas:Graphics, style:FillStyle, loop:Boolean = true):Boolean
		{
			switch (style.type)
			{
				case 0x00:
				{
					if (style.color is RGBAColor) 
					{
						canvas.beginFill(style.color.rgb, (style.color as RGBAColor).alpha / 0xFF);
					}
					else
					{
						canvas.beginFill(style.color.rgb);
					}
					
					break;
				}
					
				case 0x10:
				case 0x12:
				case 0x13:
				{
					var type:String;
					var focal:Number = 0;
					
					if (style.type == 0x10)
					{
						type = GradientType.LINEAR;
					}
					else
					{
						type = GradientType.RADIAL;
						if (style.type == 0x13)
						{
							focal = fixed((style.gradient as FocalGradient).focalPoint, 8, 8);
						}
					}
					
					var colors:Array = [];
					var alphas:Array = [];
					var ratios:Array = [];
					
					var record:GradRecord;
					var length:uint = style.gradient.gradients.length;
					for (var i:int = 0; i < length; i++)
					{
						record = style.gradient.gradients[i];
						
						colors.push(record.color.rgb);
						if (record.color is RGBAColor)
						{
							alphas.push((record.color as RGBAColor).alpha / 0xFF);
						}
						else
						{
							alphas.push(1);
						}
						
						ratios.push(record.ratio / 0xFF);
					}
					
					var spread:String;
					switch (style.gradient.spreadMode)
					{
						case 0:spread = SpreadMethod.PAD;break;
						case 1:spread = SpreadMethod.REFLECT;break;
						case 2:spread = SpreadMethod.REPEAT;break;
					}
					
					var interpolation:String;
					switch (style.gradient.interpolationMode)
					{
						case 0:interpolation = InterpolationMethod.RGB;break;
						case 1:interpolation = InterpolationMethod.LINEAR_RGB;break;
					}
					
					canvas.beginGradientFill(type, colors, alphas, ratios, style.gradientMatrix.matrix, spread, interpolation, focal);					
					break;
				}
					
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
				{
					return changeBitmapFill(canvas, style, loop);
				}
					
			}
			
			return true;
		}
		
		/**
		 * 位图填充 
		 * @param style		样式数据
		 * @param callback	设定完成后回调函数
		 */		
		private function changeBitmapFill(canvas:Graphics, style:FillStyle, loop:Boolean):Boolean
		{
			if (_dict[style.bitmapId] is DefineBitsTag)
			{
				if (_bitmaps[style.bitmapId])
				{
					canvas.beginBitmapFill(_bitmaps[style.bitmapId], style.bitmapMatrix.matrix);
					return true;
				}
				
				var bitmap:Bitmap;
				var jpeg:DefineBitsTag = _dict[style.bitmapId] as DefineBitsTag;
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					
					bitmap = e.currentTarget.content as Bitmap;
					if (jpeg is DefineBitsJPEG3Tag)
					{
						bitmap.bitmapData = (jpeg as DefineBitsJPEG3Tag).blendAlpha(bitmap.bitmapData);
					}
					
					_bitmaps[style.bitmapId] = bitmap.bitmapData;
					
					canvas.beginBitmapFill(bitmap.bitmapData, style.bitmapMatrix.matrix);
					loop && render();
				});
				
				loader.loadBytes(jpeg.data);
				return false;
			}
			
			var lossless:DefineBitsLosslessTag = _dict[style.bitmapId] as DefineBitsLosslessTag;
			canvas.beginBitmapFill(lossless.data, style.bitmapMatrix.matrix);
			return true;
		}
	}
}

class larryhou{}