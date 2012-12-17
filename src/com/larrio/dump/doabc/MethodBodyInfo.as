package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * DoABC之函数体
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:43:45 PM
	 */
	public class MethodBodyInfo implements ICodec
	{
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [MethodBodyInfo] object
		 */
		public function MethodBodyInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}
	}
}