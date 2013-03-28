package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 28, 2012 3:11:30 PM
	 */
	public class StraightEdgeRecord extends ShapeRecord
	{
		private var _numbits:uint;
		private var _lineFlag:uint;
		private var _orientationFlag:uint;
		
		private var _deltaX:int;
		private var _deltaY:int;
		
		/**
		 * 构造函数
		 * create a [StraightEdgeRecord] object
		 */
		public function StraightEdgeRecord(shape:uint)
		{
			super(shape);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			_type = 1;
			
			_numbits = decoder.readUB(4) + 2;
			_lineFlag = decoder.readUB(1);
			
			if (_lineFlag)
			{
				_deltaX = decoder.readSB(_numbits);
				_deltaY = decoder.readSB(_numbits);
			}
			else
			{
				_orientationFlag = decoder.readUB(1);
				if (_orientationFlag)
				{
					_deltaY = decoder.readSB(_numbits);
				}
				else
				{
					_deltaX = decoder.readSB(_numbits);
				}
			}			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_type, 1);
			encoder.writeUB(1, 1);
			
			encoder.writeUB(_numbits - 2, 4);
			encoder.writeUB(_lineFlag, 1);
			
			if (_lineFlag)
			{
				encoder.writeUB(_deltaX, _numbits);
				encoder.writeUB(_deltaY, _numbits);
			}
			else
			{
				encoder.writeUB(_orientationFlag, 1);
				
				if (_orientationFlag)
				{
					encoder.writeUB(_deltaY, _numbits);
				}
				else
				{
					encoder.writeUB(_deltaX, _numbits);
				}
			}
			
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<line/>");
			result.@deltaX = _deltaX;
			result.@deltaY = _deltaY;
			
			return result.toXMLString();	
		}
		
		/**
		 * delta X
		 */		
		public function get deltaX():int { return _deltaX; }

		/**
		 * delta Y
		 */		
		public function get deltaY():int { return _deltaY; }

	}
}