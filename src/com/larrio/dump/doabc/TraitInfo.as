package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * 函数特征信息
	 * @author larryhou
	 * @createTime Dec 17, 2012 9:54:37 AM
	 */
	public class TraitInfo implements ICodec
	{
		private var _name:uint;
		private var _kind:uint;
		
		
		
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [TraitInfo] object
		 */
		public function TraitInfo(constants:ConstantPool)
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