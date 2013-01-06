package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
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
		
		private var _body:MethodBodyInfo;
		
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
			var length:uint, i:int;
			
			length = _paramTypes.length;
			
			encoder.writeEU30(length);
			encoder.writeEU30(_returnType);
			
			for (i = 0; i < length; i++)
			{
				encoder.writeEU30(_paramTypes[i]);
			}
			
			encoder.writeEU30(_name);
			encoder.writeUI8(_flags);
			
			if ((_flags & MethodFlagType.HAS_OPTIONAL) == MethodFlagType.HAS_OPTIONAL)
			{
				length = _options.length;
				encoder.writeEU30(length);
				for (i = 0; i < length; i++)
				{
					_options[i].encode(encoder);
				}
			}
			
			if ((_flags & MethodFlagType.HAS_PARAM_NAMES) == MethodFlagType.HAS_PARAM_NAMES)
			{
				length = _paramNames.length;
				for (i = 0; i < length; i++)
				{
					encoder.writeEU30(_paramNames[i]);
				}
			}
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var index:int;
			var result:String = _constants.strings[_name] || "";
			
			var optionlen:int = _options? _options.length : -1;
			
			var item:String, list:Array = [];
			var length:uint = _paramTypes.length;
			
			index = -1;
			for (var i:int = 0; i < length; i++)
			{
				item = "";
				if (_paramNames)
				{
					item += _constants.strings[_paramNames[i]];
				}
				else
				{
					item += "param" + (i + 1);
				}
				
				item += ":" + _constants.multinames[_paramTypes[i]] || "*";
				if ((length - i) <= optionlen)
				{
					item += " = " + _options[++index];
				}
				
				list.push(item);
			}
			
			result += "(" + list.join(", ") + ")";
			if (_constants.multinames[_returnType])
			{
				result += ":" + _constants.multinames[_returnType];
			}
			
			return result;
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

		/**
		 * 函数体：包含执行代码
		 */		
		public function get body():MethodBodyInfo { return _body; }
		public function set body(value:MethodBodyInfo):void
		{
			_body = value;
		}

	}
}