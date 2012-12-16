package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * 命名空间集合
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:58:38 PM
	 */
	public class NamespaceSetInfo implements ICodec
	{
		private var _namespaces:Vector.<uint>;
		
		/**
		 * 构造函数
		 * create a [NamespaceSetInfo] object
		 */
		public function NamespaceSetInfo()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_namespaces = new Vector.<uint>;
			
			var length:uint = decoder.readEU30();
			while(length-- > 0) _namespaces.push(decoder.readEU30());
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}

		/**
		 * 命名空间索引数组
		 */		
		public function get namespaces():Vector.<uint> { return _namespaces; }

	}
}