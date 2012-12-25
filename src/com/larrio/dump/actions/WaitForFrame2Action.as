package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:49:50 PM
	 */
	public class WaitForFrame2Action extends SWFAction
	{
		public static const TYPE:uint = ActionType.WAIT_FOR_FRAME2;
		
		private var _skipCount:uint;
		
		/**
		 * 构造函数
		 * create a [WaitForFrame2Action] object
		 */
		public function WaitForFrame2Action()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			assertTrue(_length == 1);
			
			_skipCount = decoder.readUI8();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeUI8(_skipCount);
		}

		/**
		 * The number of actions to skip
		 */		
		public function get skipCount():uint { return _skipCount; }

	}
}