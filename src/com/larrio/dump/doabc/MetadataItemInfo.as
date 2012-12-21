package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * metadata信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 9:21:17 PM
	 */
	public class MetadataItemInfo implements ICodec
	{
		private var _key:uint;
		private var _value:uint;
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [MetadataItemInfo] object
		 */
		public function MetadataItemInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_key = decoder.readEU30();
			assertTrue(_key >= 0 && _key < _constants.strings.length);
			
			_value = decoder.readEU30();
			assertTrue(_value >= 0 && _value < _constants.strings.length);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeEU30(_key);
			encoder.writeEU30(_value);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return _constants.strings[_key] + " " + _constants.strings[_value];
		}

		/**
		 * 指向strings常量数组的索引
		 */		
		public function get key():uint { return _key; }

		/**
		 * 指向strings常量数组的索引
		 */		
		public function get value():uint { return _value; }

	}
}