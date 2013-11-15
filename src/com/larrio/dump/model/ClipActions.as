package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 26, 2012 10:33:21 AM
	 */
	public class ClipActions implements ICodec
	{
		private var _eventFlags:ClipEventFlags;
		
		private var _actionRecords:Vector.<ClipActionRecord>;
		
		private var _actionEndFlag:uint;
		
		/**
		 * 构造函数
		 * create a [ClipActions] object
		 */
		public function ClipActions()
		{
			
		}

		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			assertTrue(decoder.readUI16() == 0);
			
			_eventFlags = new ClipEventFlags();
			_eventFlags.decode(decoder);
			
			var action:ClipActionRecord;
			while (Boolean(_actionEndFlag = decoder.readUI32()) != 0)
			{
				decoder.position -= 4;
				
				action = new ClipActionRecord();
				action.decode(decoder);
				
				if (!_actionRecords)
				{
					_actionRecords = new Vector.<ClipActionRecord>();
				}
				
				_actionRecords.push(action);
			}
			trace("ClipActions");
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI16(0);
			
			_eventFlags.encode(encoder);
			
			if (_actionRecords)
			{
				var length:uint = _actionRecords.length;
				for (var i:int = 0; i < length; i++)
				{
					_actionRecords[i].encode(encoder);
				}
			}
			
			encoder.writeUI32(0);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}

		/**
		 * All events used in these clip actions
		 */		
		public function get eventFlags():ClipEventFlags { return _eventFlags; }

		/**
		 * Individual event handlers
		 */		
		public function get actionRecords():Vector.<ClipActionRecord> { return _actionRecords; }

		/**
		 * Must be 0
		 */		
		public function get actionEndFlag():uint { return _actionEndFlag; }

	}
}