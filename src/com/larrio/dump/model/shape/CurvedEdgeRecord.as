package com.larrio.dump.model.shape
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 10:49:58 PM
	 */
	public class CurvedEdgeRecord extends ShapeRecord
	{
		private var _straightFlag:uint;
		private var _numbits:uint;
		private var _controlDeltaX:int;
		private var _controlDeltaY:int;
		private var _anchorDeltaX:int;
		private var _anchorDeltaY:int;
		
		/**
		 * 构造函数
		 * create a [CurvedEdgeRecord] object
		 */
		public function CurvedEdgeRecord(shape:uint)
		{
			super(shape);	
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			_type = decoder.readUB(1);
			assertTrue(_type == 1);
			
			_straightFlag = decoder.readUB(1);
			assertTrue(_straightFlag == 0);
			
			_numbits = decoder.readUB(4);
			
			_controlDeltaX = decoder.readSB(_numbits);
			_controlDeltaY = decoder.readSB(_numbits);
			
			_anchorDeltaX = decoder.readSB(_numbits);
			_anchorDeltaY = decoder.readSB(_numbits);
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_type, 1);
			encoder.writeUB(_straightFlag, 1);
			
			encoder.writeUB(_numbits, 4);
			encoder.writeUB(_controlDeltaX, _numbits);
			encoder.writeUB(_controlDeltaY, _numbits);
			
			encoder.writeUB(_anchorDeltaX, _numbits);
			encoder.writeUB(_anchorDeltaY, _numbits);
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<CurvedEdgeRecord/>");
			result.@type = _type;
			result.@controlDeltaX = _controlDeltaX;
			result.@controlDeltaY = _controlDeltaY;
			result.@anchorDeltaX = _anchorDeltaX;
			result.@anchorDeltaY = _anchorDeltaY;
			return result.toXMLString();	
		}

		/**
		 * X control point change.
		 */		
		public function get controlDeltaX():int { return _controlDeltaX; }

		/**
		 * Y control point change.
		 */		
		public function get controlDeltaY():int { return _controlDeltaY; }

		/**
		 * X anchor point change.
		 */		
		public function get anchorDeltaX():int { return _anchorDeltaX; }

		/**
		 * Y anchor point change.
		 */		
		public function get anchorDeltaY():int { return _anchorDeltaY; }

	}
}