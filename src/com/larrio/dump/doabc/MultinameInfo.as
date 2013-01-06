package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
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
		
		private var _multiname:uint;
		private var _types:Vector.<uint>;
		
		private var _constants:ConstantPool;
		
		private var _definition:Boolean;
		
		/**
		 * 构造函数
		 * create a [MultinameInfo] object
		 */
		public function MultinameInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_kind = decoder.readUI8();
			
			var prefix:String;
			
			switch(_kind)
			{
				case MultiKindType.QNAME:
				case MultiKindType.QNAME_A:
				{
					_ns = decoder.readEU30();
					assertTrue(_ns >= 0 && _ns < _constants.namespaces.length);
					
					_name = decoder.readEU30();
					assertTrue(_name >= 0 && _name < _constants.strings.length);
					
					prefix = _constants.namespaces[_ns].toString();
					if (prefix && prefix.indexOf(":") < 0) 
					{
						prefix = _constants.strings[_name];
						if (prefix && prefix.length >= 4)
						{
							prefix = prefix.charAt(0);
							_definition = (prefix == prefix.toUpperCase());
						}
					}
					
					break;
				}
						
				case MultiKindType.RT_QNAME:
				case MultiKindType.RT_QNAME_A:
				{
					_name = decoder.readEU30();
					assertTrue(_name >= 0 && _name < _constants.strings.length);
					break;
				}
					
				case MultiKindType.RT_QNAME_L:
				case MultiKindType.RT_QNAME_LA:
				{
					break;
				}
					
				case MultiKindType.NAME_L:
				case MultiKindType.NAME_LA:
				{
					break;
				}
					
				case MultiKindType.MULTINAME:
				case MultiKindType.MULTINAME_A:
				{
					_name = decoder.readEU30();
					assertTrue(_name >= 0 && _name < _constants.strings.length);
					
					_nsset = decoder.readEU30();
					assertTrue(_nsset >= 0 && _nsset < _constants.nssets.length);
					break;
				}
					
				case MultiKindType.MULTINAME_L:
				case MultiKindType.MULTINAME_LA:
				{
					_nsset = decoder.readEU30();
					assertTrue(_nsset >= 0 && _nsset < _constants.nssets.length);
					break;
				}
					
				case MultiKindType.MULTINAME_VECTOR:
				{
					var _length:uint;
					
					_multiname = decoder.readEU30();
					assertTrue(_multiname >= 0 && _multiname < _constants.multinames.length);
					
					_length = decoder.readES30();
					_types = new Vector.<uint>(_length, true);
					for (var i:int = 0; i < _length; i++)
					{
						_types[i] = decoder.readEU30();
						assertTrue(_types[i] >= 0 && _types[i] < _constants.multinames.length);
					}
					
					break; 
				}
					
				default:
				{
					assertTrue(false);break;
				}
			}
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:uint;
			
			encoder.writeUI8(_kind);
			
			switch (_kind)
			{
				case MultiKindType.QNAME:
				case MultiKindType.QNAME_A:
				{
					encoder.writeEU30(_ns);
					encoder.writeEU30(_name);
					break;
				}
					
				case MultiKindType.RT_QNAME:
				case MultiKindType.RT_QNAME_A:
				{
					encoder.writeEU30(_name);
					break;
				}
					
				case MultiKindType.MULTINAME:
				case MultiKindType.MULTINAME_A:
				{
					encoder.writeEU30(_name);
					encoder.writeEU30(_nsset);
					break;
				}
					
				case MultiKindType.MULTINAME_L:
				case MultiKindType.MULTINAME_LA:
				{
					encoder.writeEU30(_nsset);
					break;
				}
					
				case MultiKindType.MULTINAME_VECTOR:
				{
					encoder.writeEU30(_multiname);
					
					length = _types.length;
					encoder.writeEU30(length);
					for (var i:int = 0; i < length; i++)
					{
						encoder.writeEU30(_types[i]);
					}
					break;
				}
			}
			
		}
		
		/**
		 * 输出格式化文本
		 */		
		public function toString():String
		{
			var length:uint, i:int;
			var result:String = "";
			
			var flag:Boolean;
			
			switch(_kind)
			{
				case MultiKindType.QNAME:
				case MultiKindType.QNAME_A:
				{
					result += _constants.namespaces[_ns];
					
					if (result) result += ":";
					result += _constants.strings[_name];
					break;
				}
					
				case MultiKindType.RT_QNAME:
				case MultiKindType.RT_QNAME_A:
				{
					result +=  _constants.strings[_name];
					break;
				}
					
				case MultiKindType.RT_QNAME_L:
				case MultiKindType.RT_QNAME_LA:
				{
					result += "RTQNameL";
					break;
				}
					
				case MultiKindType.NAME_L:
				case MultiKindType.NAME_LA:
				{
					result += "NameL";
					break;
				}
					
				case MultiKindType.MULTINAME:
				case MultiKindType.MULTINAME_A:
				{
					result += _constants.nssets[_nsset];
					
					if (result) result += ":";
					result += _constants.strings[_name];
					break;
				}
					
				case MultiKindType.MULTINAME_L:
				case MultiKindType.MULTINAME_LA:
				{
					result += _constants.nssets[_nsset];
					break;
				}
					
				case MultiKindType.MULTINAME_VECTOR:
				{
					result += _constants.multinames[_multiname];
					if (result) result += ".<";
					
					length = _types.length;
					for (i = 0; i < length; i++)
					{
						result += _constants.multinames[_types[i]];
					}
					
					result += ">";
					
					break; 
				}
					
			}
			
			return result;
		}

		/**
		 * 指向muilnames常量数组的索引
		 */		
		public function get multiname():uint { return _multiname; }

		/**
		 * 指向muilnames常量数组的索引
		 */		
		public function get types():Vector.<uint> { return _types; }

		/**
		 * multiname类型
		 */		
		public function get kind():uint { return _kind; }

		/**
		 * 指向strings常量数组的索引
		 */		
		public function get name():uint { return _name; }

		/**
		 * 指向namespaces常量数组的索引
		 */		
		public function get ns():uint { return _ns; }

		/**
		 * 指向nssets常量数组的索引
		 */		
		public function get nsset():uint { return _nsset; }

		/**
		 * 是否为类名
		 */		
		public function get definition():Boolean { return _definition; }
		
	}
}