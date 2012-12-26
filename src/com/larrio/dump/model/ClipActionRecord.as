package com.larrio.dump.model
{
	import com.larrio.dump.actions.ActionFactory;
	import com.larrio.dump.actions.SWFAction;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 26, 2012 10:35:17 AM
	 */
	public class ClipActionRecord implements ICodec
	{
		private var _eventFlags:ClipEventFlags;
		
		private var _size:uint;
		
		private var _keyCode:uint;
		private var _actions:Vector.<SWFAction>;
		
		/**
		 * 构造函数
		 * create a [ClipActionRecord] object
		 */
		public function ClipActionRecord()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_eventFlags = new ClipEventFlags();
			_eventFlags.decode(decoder);
			
			var byteAvailable:uint;
			byteAvailable = _size = decoder.readUI32();
			
			if (_eventFlags.keyPress)
			{
				_keyCode = decoder.readUI8();
				
				byteAvailable--;
			}
			
			if (byteAvailable)
			{
				_actions = new Vector.<SWFAction>();
			}
			
			var action:SWFAction;
			
			var type:uint;
			var position:uint, offset:uint;
			
			while(byteAvailable)
			{
				position = decoder.position;
				
				type = decoder.readUI8();
				
				decoder.position--;
				action = ActionFactory.create(type);
				action.decode(decoder);
				
				_actions.push(action);
				
				offset = decoder.position - position;
				assertTrue(offset <= byteAvailable);
				
				byteAvailable -= offset;
			}
			
			assertTrue(byteAvailable == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			_eventFlags.encode(encoder);
			
			encoder.writeUI32(_size);
			
			if (_eventFlags.keyPress)
			{
				encoder.writeUI8(_keyCode);
			}
			
			if (_actions)
			{
				var length:uint = _actions.length;
				for (var i:int = 0; i < length; i++)
				{
					_actions[i].encode(encoder);
				}
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}

		/**
		 * Events to which this handler applies
		 */		
		public function get eventFlags():ClipEventFlags { return _eventFlags; }

		/**
		 * Action record size
		 */		
		public function get size():uint { return _size; }

		/**
		 * Key code to trap
		 */		
		public function get keyCode():uint { return _keyCode; }

		/**
		 * Actions to perform
		 */		
		public function get actions():Vector.<SWFAction> { return _actions; }

	}
}