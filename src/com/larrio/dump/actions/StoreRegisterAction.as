package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 12:23:27 AM
	 */
	public class StoreRegisterAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.STORE_REGISTER;
		
		private var _register:uint;
		
		/**
		 * 构造函数
		 * create a [StoreRegisterAction] object
		 */
		public function StoreRegisterAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			_register = decoder.readUI8();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeUI8(_register);
		}

		/**
		 * register number
		 */		
		public function get register():uint { return _register; }

	}
}