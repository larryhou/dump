package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
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
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [MethodInfo] object
		 */
		public function MethodInfo(constants:ConstantPool)
		{
			_constants = constants;
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
			assertTrue(_returnType >= 0 && _returnType < _constants.multinames.length);
			
			_paramTypes = new Vector.<uint>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_paramTypes[i] = decoder.readEU30();
				assertTrue(_paramTypes[i] >= 0 && _paramTypes[i] < _constants.multinames.length);
			}
			
			_name = decoder.readEU30();
			_flags = decoder.readUI8();
			
			trace("[MethodInfo]" + (_constants.strings[_name] || "function()"));
			
			if ((_flags & MethodFlagType.HAS_OPTIONAL) == MethodFlagType.HAS_OPTIONAL)
			{
				_length = decoder.readEU30();
				_options = new Vector.<OptionInfo>(_length, true);
				for (i = 0; i < _length; i++)
				{
					_options[i] = new OptionInfo(_constants);
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
					
					assertTrue(_paramNames[i] >= 0 && _paramNames[i] < _constants.strings.length);
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

		/**
		 * 指向strings常量数组的索引
		 */		
		public function get name():uint { return _name; }

		/**
		 * 指向mutiname常量数组的索引
		 */		
		public function get returnType():uint { return _returnType; }

		/**
		 * 函数单字节标记位 
		 */		
		public function get flags():uint { return _flags; }

		/**
		 * 指向srings常量数组的索引 
		 */		
		public function get paramNames():Vector.<uint> { return _paramNames; }

		/**
		 * 函数可选参数
		 */		
		public function get options():Vector.<OptionInfo> { return _options; }

		/**
		 * 指向mutiname常量数组的索引
		 */		
		public function get paramTypes():Vector.<uint> { return _paramTypes; }

	}
}