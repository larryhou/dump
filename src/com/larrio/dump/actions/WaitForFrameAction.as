package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:02:55 PM
	 */
	public class WaitForFrameAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.WAIT_FOR_FRAME;
		
		private var _frame:uint;
		private var _skipCount:uint;
		
		/**
		 * 构造函数
		 * create a [WaitForFrameAction] object
		 */
		public function WaitForFrameAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			assertTrue(_length == 3);
			
			_frame = decoder.readUI16();
			_skipCount = decoder.readUI8();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeUI16(_frame);
			encoder.writeUI8(_skipCount);
		}

		/**
		 * Frame to wait for
		 */		
		public function get frame():uint { return _frame; }

		/**
		 * Number of actions to skip if frame is not loaded
		 */		
		public function get skipCount():uint { return _skipCount; }


	}
}