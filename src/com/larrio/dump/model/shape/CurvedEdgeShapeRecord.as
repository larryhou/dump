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
	public class CurvedEdgeShapeRecord extends ShapeRecord
	{
		private var _numbits:uint;
		
		private var _deltaControlX:int;
		private var _deltaControlY:int;
		
		private var _deltaAnchorX:int;
		private var _deltaAnchorY:int;
		
		/**
		 * 构造函数
		 * create a [CurvedEdgeRecord] object
		 */
		public function CurvedEdgeShapeRecord(shape:uint)
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
			
			_deltaControlX = decoder.readSB(_numbits);
			_deltaControlY = decoder.readSB(_numbits);
			
			_deltaAnchorX = decoder.readSB(_numbits);
			_deltaAnchorY = decoder.readSB(_numbits);
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_type, 1);
			encoder.writeUB(0, 1);
			
			encoder.writeUB(_numbits - 2, 4);
			encoder.writeUB(_deltaControlX, _numbits);
			encoder.writeUB(_deltaControlY, _numbits);
			
			encoder.writeUB(_deltaAnchorX, _numbits);
			encoder.writeUB(_deltaAnchorY, _numbits);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<curve/>");
			result.@deltaControlX = _deltaControlX;
			result.@deltaControlY = _deltaControlY;
			result.@deltaAnchorX = _deltaAnchorX;
			result.@deltaAnchorY = _deltaAnchorY;
			return result.toXMLString();	
		}

		/**
		 * X control point change.
		 */		
		public function get deltaControlX():int { return _deltaControlX; }

		/**
		 * Y control point change.
		 */		
		public function get deltaControlY():int { return _deltaControlY; }

		/**
		 * X anchor point change.
		 */		
		public function get deltaAnchorX():int { return _deltaAnchorX; }

		/**
		 * Y anchor point change.
		 */		
		public function get deltaAnchorY():int { return _deltaAnchorY; }

	}
}