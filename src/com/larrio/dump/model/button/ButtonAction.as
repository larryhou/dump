package com.larrio.dump.model.button
{
	import com.larrio.dump.actions.ActionFactory;
	import com.larrio.dump.actions.SWFAction;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 2, 2013 5:31:08 PM
	 */
	public class ButtonAction implements ICodec
	{
		private var _size:uint;
		
		private var _idleToOverDown:uint;
		private var _outDownToIdle:uint;
		private var _outDownToOverDown:uint;
		private var _overDownToOutDown:uint;
		private var _overDownToOverUp:uint;
		private var _overUpToOverDown:uint;
		private var _overUpToIdle:uint;
		private var _idleToOverUp:uint;
		private var _key:uint;
		private var _overDownToIdle:uint;
		
		private var _actions:Vector.<SWFAction>;
		
		/**
		 * 构造函数
		 * create a [ButtonAction] object
		 */
		public function ButtonAction()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_size = decoder.readUI16();
			
			_idleToOverDown = decoder.readUB(1);
			_outDownToIdle = decoder.readUB(1);
			_outDownToOverDown = decoder.readUB(1);
			_overDownToOutDown = decoder.readUB(1);
			_overDownToOverUp = decoder.readUB(1);
			_overUpToOverDown = decoder.readUB(1);
			_overUpToIdle = decoder.readUB(1);
			_idleToOverUp = decoder.readUB(1);
			
			_key = decoder.readUB(7);
			_overDownToIdle = decoder.readUB(1);
			
			_actions = new Vector.<SWFAction>();
			
			var type:uint;
			var action:SWFAction;
			while (type = decoder.readUI8())
			{
				decoder.position--;
				action = ActionFactory.create(type);
				action.decode(decoder);
				
				_actions.push(action);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI16(_size);
			
			encoder.writeUB(_idleToOverDown, 1);
			encoder.writeUB(_outDownToIdle, 1);
			encoder.writeUB(_outDownToOverDown, 1);
			encoder.writeUB(_overDownToOutDown, 1);
			encoder.writeUB(_overDownToOverUp, 1);
			encoder.writeUB(_overUpToOverDown, 1);
			encoder.writeUB(_overUpToIdle, 1);
			encoder.writeUB(_idleToOverUp, 1);
			
			encoder.writeUB(_key, 7);
			encoder.writeUB(_overDownToIdle, 1);
			
			var length:uint = _actions.length;
			for (var i:int = 0; i < length; i++)
			{
				_actions[i].encode(encoder);
			}
			
			encoder.writeUI8(0);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ButtonAction/>");
			result.@size = _size;
			result.@key = _key;
			
			result.@idleToOverDown = _idleToOverDown;
			result.@outDownToIdle = _outDownToIdle;
			result.@outDownToOverDown = _outDownToOverDown;
			result.@overDownToOutDown = _overDownToOutDown;
			result.@overDownToOverUp = _overDownToOverUp;
			result.@overUpToOverDown = _overUpToOverDown;
			result.@overUpToIdle = _overUpToIdle;
			result.@idleToOverUp = _idleToOverUp;
			result.@overDownToIdle = _overDownToIdle;
			
			var length:uint = _actions.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_actions[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Offset in bytes from start of this field to next BUTTONCONDACTION, or 0 if last action
		 */		
		public function get size():uint { return _size; }

		/**
		 * Idle to OverDown
		 */		
		public function get idleToOverDown():uint { return _idleToOverDown; }

		/**
		 * OutDown to Idle
		 */		
		public function get outDownToIdle():uint { return _outDownToIdle; }

		/**
		 * OutDown to OverDown
		 */		
		public function get outDownToOverDown():uint { return _outDownToOverDown; }

		/**
		 * OverDown to OutDown
		 */		
		public function get overDownToOutDown():uint { return _overDownToOutDown; }

		/**
		 * OverDown to OverUp
		 */		
		public function get overDownToOverUp():uint { return _overDownToOverUp; }

		/**
		 * OverUp to OverDown
		 */		
		public function get overUpToOverDown():uint { return _overUpToOverDown; }

		/**
		 * OverUp to Idle
		 */		
		public function get overUpToIdle():uint { return _overUpToIdle; }

		/**
		 * Idle to OverUp
		 */		
		public function get idleToOverUp():uint { return _idleToOverUp; }

		/**
		 * key code 
		 * Valid key codes: 
		 * 1 = left arrow
		 * 2 = right arrow
		 * 3 = home
		 * 4 = end
		 * 5 = insert
		 * 6 = delete
		 * 8 = backspace
		 * 13 = enter
		 * 14 = up arrow
		 * 15 = down arrow
		 * 16 = page up
		 * 17 = page down
		 * 18 = tab
		 * 19 = escape
		 * 32 to 126: follows ASCII
		 */		
		public function get key():uint { return _key; }

		/**
		 * OverDown to Idle
		 */		
		public function get overDownToIdle():uint { return _overDownToIdle; }

		/**
		 * Actions to perform.
		 */		
		public function get actions():Vector.<SWFAction> { return _actions; }

	}
}