package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * DoABC之函数信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:42:20 PM
	 */
	public class MethodInfo implements ICodec
	{
		private var _name:uint;
		
		private var _returnType:uint;
		private var _paramTypes:Vector.<uint>;
		
		private var _flags:uint;
		
		private var _paramNames:Vector.<uint>;
		private var _options:Vector.<OptionInfo>;
		
		/**
		 * 构造函数
		 * create a [MethodInfo] object
		 */
		public function MethodInfo()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var _length:uint, i:int;
			
			_length = decoder.readEU30();
			_returnType = decoder.readEU30();
			
			_paramTypes = new Vector.<uint>(_length, true);
			for (i = 0; i < length; i++)
			{
				_paramTypes.push(decoder.readEU30());
			}
			
			_name = decoder.readEU30();
			_flags = decoder.readUI8();
			
			if ((_flags & MethodFlagType.HAS_OPTIONAL) == MethodFlagType.HAS_OPTIONAL)
			{
				_length = decoder.readEU30();
				_options = new Vector.<OptionInfo>(_length, true);
				for (i = 0; i < _length; i++)
				{
					_options[i] = new OptionInfo();
					_options[i].decode(decoder);
				}
			}
			
			if ((_flags & MethodFlagType.HAS_PARAM_NAMES) == MethodFlagType.HAS_PARAM_NAMES)
			{
				_length = _paramTypes.length;
				_paramNames = new Vector.<uint>(_length, true);
				for (i = 0; i < _length; i++)
				{
					_paramNames[i] = decoder.readEU30();
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