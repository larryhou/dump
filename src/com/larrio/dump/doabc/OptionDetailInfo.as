package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * 可选传参详细信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 6:43:27 PM
	 */
	public class OptionDetailInfo implements ICodec
	{
		private var _value:uint;
		private var _kind:uint;
		
		/**
		 * 构造函数
		 * create a [OptionDetailInfo] object
		 */
		public function OptionDetailInfo()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_value = decoder.readEU30();
			_kind = decoder.readUI8();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}

		/**
		 * 指向常量池某个数组的索引值 
		 */		
		public function get value():uint { return _value; }

		/**
		 * 该属性确定了value具体指向哪个常量数组 
		 * @return 
		 * 
		 */		
		public function get kind():uint { return _kind; }

	}
}