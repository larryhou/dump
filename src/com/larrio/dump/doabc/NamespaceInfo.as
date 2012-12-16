package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * DoABC之命名空间
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:57:20 PM
	 */
	public class NamespaceInfo implements ICodec
	{
		private var _kind:uint;
		private var _name:uint;
		
		/**
		 * 构造函数
		 * create a [NamespaceInfo] object
		 */
		public function NamespaceInfo()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_kind = decoder.readUI8();
			_name = decoder.readEU30();
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