package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 12:45:52 PM
	 */
	public class StyleChangeRecord extends ShapeRecord
	{
		private var _stateNewStyles:uint;
		private var _stateLineStyle:uint;
		private var _stateFillStyle1:uint;
		private var _stateFillStyle0:uint;
		private var _stateMoveTo:uint;
		
		private var _moveBits:uint;
		private var _moveDeltaX:int;
		private var _moveDeltaY:int;
		
		private var _fillBits:uint;
		private var _fillStyle0:uint;
		private var _fillStyle1:uint;
		
		private var _lineBits:uint;
		private var _lineStyle:uint;
		
		private var _fillStyles:FillStyleArray;
		private var _lineStyles:LineStyleArray;
		
		private var _numFillBits:uint;
		private var _numLineBits:uint;
		
		/**
		 * 构造函数
		 * create a [StyleChangeRecord] object
		 */
		public function StyleChangeRecord(shape:uint, fillBits:uint, lineBits:uint)
		{
			_fillBits = fillBits;
			_lineBits = lineBits;
			
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			_type = decoder.readUB(1);
			assertTrue(_type == 0);
			
			_stateNewStyles = decoder.readUB(1);
			_stateLineStyle = decoder.readUB(1);
			_stateFillStyle1 = decoder.readUB(1);
			_stateFillStyle1 = decoder.readUB(1);
			_stateMoveTo = decoder.readUB(1);
			
			if (_stateMoveTo)
			{
				_moveBits = decoder.readUB(5);
				_moveDeltaX = decoder.readSB(_moveBits);
				_moveDeltaY = decoder.readSB(_moveBits);
			}
			
			if (_stateFillStyle0)
			{
				_fillStyle0 = decoder.readUB(_fillBits);
			}
			
			if (_stateFillStyle1)
			{
				_fillStyle1 = decoder.readUB(_fillBits);
			}
			
			if (_stateLineStyle)
			{
				_lineStyle = decoder.readUB(_lineBits);
			}
			
			if (_stateNewStyles)
			{
				_fillStyles = new FillStyleArray(_shape);
				_fillStyles.decode(decoder);
				
				_lineStyles = new LineStyleArray(_shape);
				_lineStyles.decode(decoder);
				
				_numFillBits = decoder.readUB(4);
				_numLineBits = decoder.readUB(4);
			}
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_type, 1);
			encoder.writeUB(_stateNewStyles, 1);
			encoder.writeUB(_stateLineStyle, 1);
			encoder.writeUB(_stateFillStyle1, 1);
			encoder.writeUB(_stateFillStyle0, 1);
			encoder.writeUB(_stateMoveTo, 1);
			
			if (_stateMoveTo)
			{
				encoder.writeUB(_moveBits, 5);
				encoder.writeUB(_moveDeltaX, _moveBits);
				encoder.writeUB(_moveDeltaY, _moveBits);
			}
			
			if (_stateFillStyle0)
			{
				encoder.writeUB(_fillStyle0, _fillBits);
			}
			
			if (_stateFillStyle1)
			{
				encoder.writeUB(_fillStyle1, _fillBits);
			}
			
			if (_stateLineStyle)
			{
				encoder.writeUB(_lineStyle, _lineBits);
			}
			
			if (_stateNewStyles)
			{
				_fillStyles.encode(encoder);
				_lineStyles.encode(encoder);
				
				encoder.writeUB(_numFillBits, 4);
				encoder.writeUB(_numLineBits, 4);
			}
			
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<StyleChangeRecord/>");
			result.@type = _type;
			if (_stateMoveTo)
			{
				result.@moveDeltaX = _moveDeltaX;
				result.@moveDeltaY = _moveDeltaY;
			}
			
			if (_stateFillStyle0)
			{
				result.@fillStyle0 = _fillStyle0;
			}
			
			if (_stateFillStyle1)
			{
				result.@fillStyle1 = _fillStyle1;
			}
			
			if (_stateLineStyle)
			{
				result.@lineStyle = _lineStyle;
			}
			
			if (_stateNewStyles)
			{
				result.appendChild(new XML(_fillStyles.toString()));
				result.appendChild(new XML(_lineStyles.toString()));
			}
			
			return result.toXMLString();	
		}		

		/**
		 * Move bit count.
		 */		
		public function get moveBits():uint { return _moveBits; }

		/**
		 * Delta X value.
		 */		
		public function get moveDeltaX():uint { return _moveDeltaX; }

		/**
		 * Delta Y value.
		 */		
		public function get moveDeltaY():uint { return _moveDeltaY; }

		/**
		 * Fill 0 Style.
		 */		
		public function get fillStyle0():uint { return _fillStyle0; }

		/**
		 * Fill 1 Style.
		 */		
		public function get fillStyle1():uint { return _fillStyle1; }

		/**
		 * Line Style.
		 */		
		public function get lineStyle():uint { return _lineStyle; }

		/**
		 * Array of new fill styles.
		 */		
		public function get fillStyles():FillStyleArray { return _fillStyles; }

		/**
		 * Array of new line styles.
		 */		
		public function get lineStyles():LineStyleArray { return _lineStyles; }

		/**
		 * Number of fill index bits for new styles.
		 */		
		public function get numFillBits():uint { return _numFillBits; }

		/**
		 * Number of line index bits for new styles.
		 */		
		public function get numLineBits():uint { return _numLineBits; }

	}
}