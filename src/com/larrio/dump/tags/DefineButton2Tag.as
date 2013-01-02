package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.button.ButtonAction;
	import com.larrio.dump.model.button.ButtonRecord;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:25:10 PM
	 */
	public class DefineButton2Tag extends DefineButtonTag
	{
		public static const TYPE:uint = TagType.DEFINE_BUTTON2;
		
		private var _trackAsMenu:uint;
		private var _actionOffset:uint;
		
		private var _lenR:uint;
		
		/**
		 * 构造函数
		 * create a [DefineButton2Tag] object
		 */
		public function DefineButton2Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_dict[_character] = this;
			
			assertTrue(decoder.readUB(7) == 0);
			_trackAsMenu = decoder.readUB(1);
			
			_actionOffset = decoder.readUI16();
			
			_records = new Vector.<ButtonRecord>();
			
			var record:ButtonRecord;
			while (decoder.readUI8())
			{
				decoder.position--;
				
				record = new ButtonRecord(_type);
				record.decode(decoder);
				
				_records.push(record);
			}
			
			var action:ButtonAction;
			if (_actionOffset > 0)
			{
				_actions = new Vector.<ICodec>();
				while (decoder.readUI16())
				{
					decoder.position -= 2;
					
					action = new ButtonAction();
					action.decode(decoder);
					
					_actions.push(action);
				}
			}
			
			trace(this);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			encoder.writeUB(0, 7);
			encoder.writeUB(_trackAsMenu, 1);
			
			encoder.writeUI16(_actionOffset);
			
			var length:uint, i:int;
			length = _records.length;
			for (i = 0; i < length; i++)
			{
				_records[i].encode(encoder);
			}
			
			encoder.writeUI8(0);
			
			if (_actionOffset > 0)
			{
				length = _actions.length;
				for (i = 0; i < length; i++)
				{
					_actions[i].encode(encoder);
				}
				
				encoder.writeUI16(0);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<DefineButton2Tag/>");
			result.@character = _character;
			result.@trackAsMenu = Boolean(_trackAsMenu);
			
			var length:uint, i:int;
			length = _records.length;
			for (i = 0; i < length; i++)
			{
				result.appendChild(new XML(_records[i].toString()));
			}
			
			if (_actionOffset > 0)
			{
				length = _actions.length;
				for (i = 0; i < length; i++)
				{
					result.appendChild(new XML("" + _actions[i]));
				}
			}
			
			return result.toXMLString();	
		}

		/**
		 * 0 = track as normal button 
		 * 1 = track as menu button
		 */		
		public function get trackAsMenu():uint { return _trackAsMenu; }

		/**
		 * 
		 */		
		public function get actionOffset():uint { return _actionOffset; }

	}
}