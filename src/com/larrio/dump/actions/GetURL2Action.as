package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:34:06 PM
	 */
	public class GetURL2Action extends SWFAction
	{
		public static const TYPE:uint = ActionType.GET_URL2;
		
		private var _sendVarsMethod:uint;
		private var _loadTargetFlag:uint;
		private var _loadVariablesFlag:uint;
		
		/**
		 * 构造函数
		 * create a [GetURL2Action] object
		 */
		public function GetURL2Action()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			assertTrue(_length == 1);
			
			_sendVarsMethod = decoder.readUB(2);
			
			assertTrue(decoder.readUB(4) == 0);
			
			_loadTargetFlag = decoder.readUB(1);
			_loadVariablesFlag = decoder.readUB(1);
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeUB(_sendVarsMethod, 2);
			encoder.writeUB(0, 4);
			encoder.writeUB(_loadTargetFlag, 1);
			encoder.writeUB(_loadVariablesFlag, 1);
			encoder.flush();
		}

		/**
		 * 0 = None 
		 * 1 = GET
		 * 2 = POST
		 */		
		public function get sendVarsMethod():uint { return _sendVarsMethod; }

		/**
		 * 0 = Target is a browser window 
		 * 1 = Target is a path to a sprite
		 */		
		public function get loadTargetFlag():uint { return _loadTargetFlag; }

		/**
		 * 0 = No variables to load 
		 * 1 = Load variables
		 */		
		public function get loadVariablesFlag():uint { return _loadVariablesFlag; }

	}
}