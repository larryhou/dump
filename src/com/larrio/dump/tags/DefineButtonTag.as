package com.larrio.dump.tags
{
	import com.larrio.dump.actions.ActionFactory;
	import com.larrio.dump.actions.SWFAction;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.button.ButtonRecord;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:24:29 PM
	 */
	public class DefineButtonTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_BUTTON;
		
		protected var _records:Vector.<ButtonRecord>;
		protected var _actions:Vector.<ICodec>;
		
		/**
		 * 构造函数
		 * create a [DefineButtonTag] object
		 */
		public function DefineButtonTag()
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
			
			_records = new Vector.<ButtonRecord>();
			
			var record:ButtonRecord;
			while (decoder.readUI8())
			{
				decoder.position--;
				record = new ButtonRecord(_type);
				record.decode(decoder);
				
				_records.push(record);
			}
			
			_actions = new Vector.<ICodec>();
			
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
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			var length:uint, i:int;
			
			length = _records.length;
			for (i = 0; i < length; i++)
			{
				_records[i].encode(encoder);
			}
			
			encoder.writeUI8(0);
			
			length = _actions.length;
			for (i = 0; i < length; i++)
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
			var result:XML = new XML("<DefineButtonTag/>");
			result.@character = _character;
			
			var length:uint, i:int;
			
			length = _records.length;
			for (i = 0; i < length; i++)
			{
				result.appendChild(new XML(_records[i].toString()));
			}
			
			length = _actions.length;
			for (i = 0; i < length; i++)
			{
				result.appendChild(new XML("" + _actions[i]));
			}

			return result.toXMLString();	
		}

		/**
		 * Characters that make up the more] button
		 */		
		public function get records():Vector.<ButtonRecord> { return _records; }

		/**
		 * Actions to perform
		 */		
		public function get actions():Vector.<ICodec> { return _actions; }

	}
}