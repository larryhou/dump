package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 9:58:44 AM
	 */
	public class RegisterParam implements ICodec
	{
		private var _register:uint;
		private var _name:String;
		
		/**
		 * 构造函数
		 * create a [RegisterParam] object
		 */
		public function RegisterParam()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_register = decoder.readUI8();
			_name = decoder.readSTR();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(_register);
			encoder.writeSTR(_name);
		}

		/**
		 * For each parameter to the function, a register can be specified.
		 * If the register specified is zero, the parameter is created as a variable named ParamName in the activation object, which can be referenced with ActionGetVariable and ActionSetVariable.
		 * If the register specified is nonzero, the parameter is copied into the register, and it can be referenced with ActionPush and ActionStoreRegister, and no variable is created in the activation object.
		 */		
		public function get register():uint { return _register; }

		/**
		 * parameter name
		 */		
		public function get name():String { return _name; }
		
	}
}