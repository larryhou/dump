package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * 函数可选传参信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 6:22:05 PM
	 */
	public class OptionInfo implements ICodec
	{
		private var _details:Vector.<OptionDetailInfo>;
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [OptionInfo] object
		 */
		public function OptionInfo(constant:ConstantPool)
		{
			_constants = constant;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var _length:uint, i:int;
			
			_length = decoder.readES30();
			_details = new Vector.<OptionDetailInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_details[i] = new OptionDetailInfo(_constants);
				_details[i].decode(decoder);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}

		/**
		 * 可选参数详细信息
		 */		
		public function get details():Vector.<OptionDetailInfo> { return _details; }

	}
}