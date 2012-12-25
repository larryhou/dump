package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:40:07 PM
	 */
	public class GotoFrame2Action extends SWFAction
	{
		public static const TYPE:uint = ActionType.GOTO_FRAME2;
		
		private var _sceneBiasFlag:uint;
		private var _playFlag:uint;
		private var _sceneBias:uint;
		
		/**
		 * 构造函数
		 * create a [GotoFrame2Action] object
		 */
		public function GotoFrame2Action()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			assertTrue(decoder.readUB(6) == 0);
			
			_sceneBiasFlag = decoder.readUB(1);
			_playFlag = decoder.readUB(1);
			
			if (_sceneBiasFlag)
			{
				_sceneBias = decoder.readUI16();
			}
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeUB(0, 6);
			encoder.writeUB(_sceneBiasFlag, 1);
			encoder.writeUB(_playFlag, 1);
			encoder.flush();
			
			if (_sceneBiasFlag)
			{
				encoder.writeUI16(_sceneBias);
			}
		}
		
		/**
		 * Scene bias flag
		 */		
		public function get sceneBiasFlag():uint { return _sceneBiasFlag; }

		/**
		 * 0 = Go to frame and stop 
		 * 1 = Go to frame and play
		 */		
		public function get playFlag():uint { return _playFlag; }

		/**
		 * Number to be added to frame determined by stack argument
		 */		
		public function get sceneBias():uint { return _sceneBias; }

	}
}