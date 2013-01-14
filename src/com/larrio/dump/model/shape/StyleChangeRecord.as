package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	
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
		
		private var _movebits:uint;
		private var _moveToX:int;
		private var _moveToY:int;
		
		private var _fillStyle0:uint;
		private var _fillStyle1:uint;
		
		private var _lineStyle:uint;
		
		private var _fillStyles:FillStyleArray;
		private var _lineStyles:LineStyleArray;
		
		private var _numfbits:uint;
		private var _numlbits:uint;
		private var _inumfbits:uint;
		private var _inumlbits:uint;
		
		/**
		 * 构造函数
		 * create a [StyleChangeRecord] object
		 */
		public function StyleChangeRecord(shape:uint, numfbits:uint, numlbits:uint, flag:uint)
		{
			_numfbits = _inumfbits = numfbits;
			_numlbits = _inumlbits = numlbits;
			
			_stateMoveTo = flag & 1;
			_stateFillStyle0 = (flag >>= 1) & 1;
			_stateFillStyle1 = (flag >>= 1) & 1;
			_stateLineStyle = (flag >>= 1) & 1;
			_stateNewStyles = (flag >> 1) & 1;
			
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			_type = 0;
			
			if (_stateMoveTo)
			{
				_movebits = decoder.readUB(5);
				_moveToX = decoder.readSB(_movebits);
				_moveToY = decoder.readSB(_movebits);
			}
			
			if (_stateFillStyle0)
			{
				_fillStyle0 = decoder.readUB(_inumfbits);
			}
			
			if (_stateFillStyle1)
			{
				_fillStyle1 = decoder.readUB(_inumfbits);
			}
			
			if (_stateLineStyle)
			{
				_lineStyle = decoder.readUB(_inumlbits);
			}
			
			if (_stateNewStyles)
			{
				_fillStyles = new FillStyleArray(_shape);
				_fillStyles.decode(decoder);
				
				_lineStyles = new LineStyleArray(_shape);
				_lineStyles.decode(decoder);
				decoder.byteAlign();
				
				_numfbits = decoder.readUB(4);
				_numlbits = decoder.readUB(4);
			}
			
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
				encoder.writeUB(_movebits, 5);
				encoder.writeUB(_moveToX, _movebits);
				encoder.writeUB(_moveToY, _movebits);
			}
			
			if (_stateFillStyle0)
			{
				encoder.writeUB(_fillStyle0, _inumfbits);
			}
			
			if (_stateFillStyle1)
			{
				encoder.writeUB(_fillStyle1, _inumfbits);
			}
			
			if (_stateLineStyle)
			{
				encoder.writeUB(_lineStyle, _inumlbits);
			}
			
			if (_stateNewStyles)
			{
				_fillStyles.encode(encoder);
				_lineStyles.encode(encoder);
				encoder.flush();
				
				encoder.writeUB(_numfbits, 4);
				encoder.writeUB(_numlbits, 4);
			}
			
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<styleChange/>");
			
			if (_stateMoveTo)
			{
				result.@moveToX = _moveToX;
				result.@moveToY = _moveToY;
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
		public function get movebits():uint { return _movebits; }

		/**
		 * Delta X value.
		 */		
		public function get moveToX():uint { return _moveToX; }

		/**
		 * Delta Y value.
		 */		
		public function get moveToY():uint { return _moveToY; }

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
		public function get numfbits():uint { return _numfbits; }

		/**
		 * Number of line index bits for new styles.
		 */		
		public function get numlbits():uint { return _numlbits; }

		/**
		 * 是否需要更换新样式
		 */		
		public function get stateNewStyles():uint { return _stateNewStyles; }

		/**
		 * 是否设置线型
		 */		
		public function get stateLineStyle():uint { return _stateLineStyle; }

		/**
		 * 是否这f1样式
		 */		
		public function get stateFillStyle1():uint { return _stateFillStyle1; }

		/**
		 * 是否设置f0样式
		 */		
		public function get stateFillStyle0():uint { return _stateFillStyle0; }

		/**
		 * 是否需要移动
		 */		
		public function get stateMoveTo():uint { return _stateMoveTo; }

	}
}