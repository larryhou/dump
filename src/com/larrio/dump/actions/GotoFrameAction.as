package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 10:49:31 PM
	 */
	public class GotoFrameAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.GOTO_FRAME;
		
		private var _frame:uint;
		
		/**
		 * 构造函数
		 * create a [GotoFrameAction] object
		 */
		public function GotoFrameAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			assertTrue(_length == 2);
			
			_frame = decoder.readUI16();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeUI16(_length);
		}

		/**
		 * frame index
		 */		
		public function get frame():uint { return _frame; }

	}
}