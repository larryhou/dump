package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 16, 2012 4:00:46 PM
	 */
	public class MultinameInfo implements ICodec
	{
		private var _kind:uint;
		private var _name:uint;
		
		private var _ns:uint;
		private var _nsset:uint;
		
		
		/**
		 * 构造函数
		 * create a [MultinameInfo] object
		 */
		public function MultinameInfo()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_kind = decoder.readUI8();
			
			switch(_kind)
			{
				case MultiKindType.QNAME:
				{
					_ns = decoder.readEU30();
					_name = decoder.readEU30();
					break;
				}
						
				case MultiKindType.RT_QNAME:
				case MultiKindType.RT_QNAME_A:
				{
					_name = decoder.readEU30();
					break;
				}
					
				case MultiKindType.RT_QNAME_L:
				case MultiKindType.RT_QNAME_LA:
				{
					break;
				}
					
				case MultiKindType.MULTINAME:
				case MultiKindType.MULTINAME_A:
				{
					_name = decoder.readEU30();
					_nsset = decoder.readEU30();
					break;
				}
					
				case MultiKindType.MULTINAME_L:
				case MultiKindType.MULTINAME_LA:
				{
					_nsset = decoder.readEU30();
					break;
				}
			}
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