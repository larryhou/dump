package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.RegisterParam;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 12:30:57 AM
	 */
	public class DefineFunction2Action extends SWFAction
	{
		public static const TYPE:uint = ActionType.DEFINE_FUNCTION2;
		
		private var _name:String;
		
		private var _numParams:uint;
		private var _registerCount:uint;
		
		private var _preloadParentFlag:uint;
		private var _preloadRootFlag:uint;
		
		private var _suppressSuperFlag:uint;
		private var _preloadSuperFlag:uint;
		
		private var _suppressArgumentsFlag:uint;
		private var _preloadArgumentsFlag:uint;
		
		private var _suppressThisFlag:uint;
		private var _preloadThisFlag:uint;
		
		private var _preloadGlobalFlag:uint;
		
		private var _parameters:Vector.<RegisterParam>;
		
		private var _codeSize:uint;
		
		/**
		 * 构造函数
		 * create a [DefineFunction2Action] object
		 */
		public function DefineFunction2Action()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			_name = decoder.readSTR();
			
			_numParams = decoder.readUI16();
			_registerCount = decoder.readUI8();
			
			_preloadParentFlag = decoder.readUB(1);
			_preloadRootFlag = decoder.readUB(1);
			
			_suppressSuperFlag = decoder.readUB(1);
			_preloadSuperFlag = decoder.readUB(1);
			
			_suppressArgumentsFlag = decoder.readUB(1);
			_preloadArgumentsFlag = decoder.readUB(1);
			
			_suppressThisFlag = decoder.readUB(1);
			_preloadThisFlag = decoder.readUB(1);
			
			assertTrue(decoder.readUB(7) == 0);
			
			_preloadGlobalFlag = decoder.readUB(1);
			
			_parameters = new Vector.<RegisterParam>(_numParams, true);
			for (var i:int = 0; i < _numParams; i++)
			{
				_parameters[i] = new RegisterParam();
				_parameters[i].decode(decoder);
			}
			
			_codeSize = decoder.readUI16();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeSTR(_name);
			
			encoder.writeUI16(_numParams);
			encoder.writeUI8(_registerCount);
			
			encoder.writeUB(_preloadParentFlag, 1);
			encoder.writeUB(_preloadRootFlag, 1);
			
			encoder.writeUB(_suppressSuperFlag, 1);
			encoder.writeUB(_preloadSuperFlag, 1);
			
			encoder.writeUB(_suppressArgumentsFlag, 1);
			encoder.writeUB(_preloadArgumentsFlag, 1);
			
			encoder.writeUB(_suppressThisFlag, 1);
			encoder.writeUB(_preloadThisFlag, 1);
			
			encoder.writeUB(0, 7);
			encoder.writeUB(_preloadGlobalFlag, 1);
			encoder.flush();
			
			for (var i:int = 0; i < _numParams; i++)
			{
				_parameters[i].encode(encoder);
			}
			
			encoder.writeUI16(_codeSize);
		}

		/**
		 * Name of function, empty if anonymous
		 */		
		public function get name():String { return _name; }

		/**
		 * # of parameters
		 */		
		public function get numParams():uint { return _numParams; }

		/**
		 * Number of registers to allocate, up to 255 registers(from 0 to 254)
		 */		
		public function get registerCount():uint { return _registerCount; }

		/**
		 * 0 = Don’t preload _parent into register
		 * 1 = Preload _parent into register
		 */		
		public function get preloadParentFlag():uint { return _preloadParentFlag; }

		/**
		 * 0 = Don’t preload _root into register
		 * 1 = Preload _root into register
		 */		
		public function get preloadRootFlag():uint { return _preloadRootFlag; }

		/**
		 * 0 = Create super variable 
		 * 1 = Don’t create super variable
		 */		
		public function get suppressSuperFlag():uint { return _suppressSuperFlag; }

		/**
		 * 0 = Don’t preload super into register
		 * 1 = Preload super into register
		 */		
		public function get preloadSuperFlag():uint { return _preloadSuperFlag; }

		/**
		 * 0 = Create arguments variable
		 * 1 = Don’t create arguments variable
		 */		
		public function get suppressArgumentsFlag():uint { return _suppressArgumentsFlag; }

		/**
		 * 0 = Don’t preload arguments into register
		 * 1 = Preload arguments into register
		 */		
		public function get preloadArgumentsFlag():uint { return _preloadArgumentsFlag; }

		/**
		 * 0 = Create this variable
		 * 1 = Don’t create this variable
		 */		
		public function get suppressThisFlag():uint { return _suppressThisFlag; }

		/**
		 * 0 = Don’t preload this into register
		 * 1 = Preload this into register
		 */		
		public function get preloadThisFlag():uint { return _preloadThisFlag; }

		/**
		 * 0 = Don’t preload _global into register
		 * 1 = Preload _global into register
		 */		
		public function get preloadGlobalFlag():uint { return _preloadGlobalFlag; }

		/**
		 * parameters
		 */		
		public function get parameters():Vector.<RegisterParam> { return _parameters; }

		/**
		 * # of bytes of code that follow
		 */		
		public function get codeSize():uint { return _codeSize; }

	}
}