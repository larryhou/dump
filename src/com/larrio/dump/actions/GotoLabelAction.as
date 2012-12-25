package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:08:30 PM
	 */
	public class GotoLabelAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.GOTO_LABEL;
		
		private var _label:String;
		
		/**
		 * 构造函数
		 * create a [GotoLabelAction] object
		 */
		public function GotoLabelAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			_label = decoder.readSTR();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeSTR(_label);
		}

		/**
		 * frame label
		 */		
		public function get label():String { return _label; }

	}
}