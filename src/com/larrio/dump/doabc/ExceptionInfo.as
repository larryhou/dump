package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * handler
	 * @author larryhou
	 * @createTime Dec 17, 2012 12:06:41 PM
	 */
	public class ExceptionInfo implements ICodec
	{
		private var _from:uint;
		private var _to:uint;
		
		private var _target:uint;
		private var _type:uint;
		private var _name:uint;
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [ExceptionInfo] object
		 */
		public function ExceptionInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_from = decoder.readEU30();
			_to = decoder.readEU30();
			
			_target = decoder.readEU30();
			
			_type = decoder.readEU30();
			_name = decoder.readEU30();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:String = "";
			result += _constants.strings[_name] + " type:" + _constants.strings[_type];
			result += " from:" + _from + " to:" + _to + " target:" + _target;
			
			return result;
		}

		/**
		 * 异常作用域上限code字节位置
		 */		
		public function get from():uint { return _from; }

		/**
		 * 异常作用域下限code字节位置
		 */		
		public function get to():uint { return _to; }

		/**
		 * 代码遇到异常时跳到的code字节位置
		 */		
		public function get target():uint { return _target; }

		/**
		 * 异常标记字符串：指向strings常量数组的索引
		 */		
		public function get type():uint { return _type; }

		/**
		 * 异常传参名称：指向strings常量数组的索引
		 */		
		public function get name():uint { return _name; }
	}
}