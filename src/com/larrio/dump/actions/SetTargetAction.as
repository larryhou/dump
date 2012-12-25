package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:06:11 PM
	 */
	public class SetTargetAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.SET_TARGET;
		
		private var _name:String;
		
		/**
		 * 构造函数
		 * create a [SetTargetAction] object
		 */
		public function SetTargetAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			_name = decoder.readSTR();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeSTR(_name);
		}

		/**
		 * Target of action target
		 */		
		public function get name():String { return _name; }

	}
}