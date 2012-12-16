package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	import com.larrio.utils.assertTrue;
	
	/**
	 * DoABC之命名空间
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:57:20 PM
	 */
	public class NamespaceInfo implements ICodec
	{
		private var _kind:uint;
		private var _name:uint;
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [NamespaceInfo] object
		 */
		public function NamespaceInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_kind = decoder.readUI8();
			_name = decoder.readEU30();
			
			// TODO: hard code unit test
			assertTrue(_name >= 0 && _name < _constants.strings.length);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}

		/**
		 * @see NSKindType
		 */		
		public function get kind():uint { return _kind; }

		/**
		 * 命名空间标识符索引
		 */		
		public function get name():uint { return _name; }


	}
}