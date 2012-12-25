package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:28:03 PM
	 */
	public class JumpAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.JUMP;
		
		protected var _offset:int;
		
		/**
		 * 构造函数
		 * create a [JumpAction] object
		 */
		public function JumpAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			_offset = decoder.readS16();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeS16(_offset);
		}

		/**
		 * jump offset
		 */		
		public function get offset():int { return _offset; }

	}
}