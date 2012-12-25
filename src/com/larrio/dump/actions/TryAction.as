package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 12:34:32 AM
	 */
	public class TryAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.TRY;
		
		private var _catchInRegisterFlag:uint;
		private var _finallyBlockFlag:uint;
		private var _catchBlockFlag:uint;
		
		private var _trySize:uint;
		private var _catchSize:uint;
		private var _finallySize:uint;
		
		private var _catchName:String;
		private var _catchRegister:uint;
		
		private var _tryBody:ByteArray;
		private var _catchBody:ByteArray;
		private var _finallyBody:ByteArray;
		
		
		/**
		 * 构造函数
		 * create a [TryAction] object
		 */
		public function TryAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			assertTrue(decoder.readUB(5) == 0);
			
			_catchInRegisterFlag = decoder.readUB(1);
			_finallyBlockFlag = decoder.readUB(1);
			_catchBlockFlag = decoder.readUB(1);
			
			_trySize = decoder.readUI16();
			_catchSize = decoder.readUI16();
			_finallySize = decoder.readUI16();
			
			if (_catchInRegisterFlag == 0)
			{
				_catchName = decoder.readSTR();
			}
			else
			{
				_catchRegister = decoder.readUI8();
			}
			
			_tryBody = new ByteArray();
			decoder.readBytes(_tryBody, 0, _trySize);
				
			if (_catchSize)
			{
				_catchBody = new ByteArray();
				decoder.readBytes(_catchBody, 0, _catchSize);
			}
			
			if (_finallySize)
			{
				_finallyBody = new ByteArray();
				decoder.readBytes(_finallyBody, 0, _finallySize);
			}
			
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeUB(0, 5);
			encoder.writeUB(_catchInRegisterFlag, 1);
			encoder.writeUB(_finallyBlockFlag, 1);
			encoder.writeUB(_catchBlockFlag, 1);
			
			encoder.writeUI16(_trySize);
			encoder.writeUI16(_catchSize);
			encoder.writeUI16(_finallySize);
			
			if (_catchInRegisterFlag == 0)
			{
				encoder.writeSTR(_catchName);
			}
			else
			{
				encoder.writeUI8(_catchRegister);
			}
			
			encoder.writeBytes(_tryBody);
			
			if (_catchSize)
			{
				encoder.writeBytes(_catchBody);
			}
			
			if (_finallySize)
			{
				encoder.writeBytes(_finallyBody);
			}
		}

		/**
		 * 0 - Do not put caught object into register (instead, store in named variable)
		 * 1 - Put caught object into register (do not store in named variable)
		 */		
		public function get catchInRegisterFlag():uint { return _catchInRegisterFlag; }

		/**
		 * 0 - No finally block 
		 * 1 - Has finally block
		 */		
		public function get finallyBlockFlag():uint { return _finallyBlockFlag; }

		/**
		 * 0 - No catch block 
		 * 1 - Has catch block
		 */		
		public function get catchBlockFlag():uint { return _catchBlockFlag; }

		/**
		 * Length of the try block
		 */		
		public function get trySize():uint { return _trySize; }

		/**
		 * Length of the catch block
		 */		
		public function get catchSize():uint { return _catchSize; }

		/**
		 * Length of the finally block
		 */		
		public function get finallySize():uint { return _finallySize; }

		/**
		 * Name of the catch variable
		 */		
		public function get catchName():String { return _catchName; }

		/**
		 * Register to catch into
		 */		
		public function get catchRegister():uint { return _catchRegister; }

		/**
		 * Body of the try block
		 */		
		public function get tryBody():ByteArray { return _tryBody; }

		/**
		 * Body of the catch block, if any
		 */		
		public function get catchBody():ByteArray { return _catchBody; }

		/**
		 * Body of the finally block, if any
		 */		
		public function get finallyBody():ByteArray { return _finallyBody; }

	}
}