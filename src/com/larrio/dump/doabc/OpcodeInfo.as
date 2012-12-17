package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.dump.utils.padding;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	/**
	 * 解析opcode指令
	 * @author larryhou
	 * @createTime Dec 17, 2012 1:36:53 PM
	 */
	public class OpcodeInfo implements ICodec
	{
		private static var _map:Dictionary;
		
		private var _bytes:ByteArray;
		
		private var _code:String;
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [OpcodeInfo] object
		 */
		public function OpcodeInfo(constants:ConstantPool)
		{
			_constants = constants;
			
			if (!_map)
			{
				_map = new Dictionary(false);
				
				var key:String;
				var config:XMLList = describeType(OpcodeType).constant;
				for each (var node:XML in config)
				{
					key = String(node.@name);
					
					_map[OpcodeType[key]] = key.replace(/_OP$/i, "").toLowerCase();
				}
			}
		}
		
		/**
		 * 获取字符串常量
		 * @param index	指向constants常量数组的索引
		 * @return 字符串
		 * 
		 */		
		private function getSTR(index:uint):String
		{
			var strings:Vector.<String> = _constants.strings;
			assertTrue(index >= 0 && index < strings.length);
			
			if (index == 0) return '""';
			return '"' + strings[index].replace("\n", "\\n").replace("\t", "\\t") + '"';
		}
		
		/**
		 * 获取命名空间 
		 * @param index	指向namespaces常量数组的索引
		 * @return 字符串
		 */		
		private function getNS(index:uint):String
		{
			var namespaces:Vector.<NamespaceInfo> = _constants.namespaces;
			assertTrue(index >= 0 && index < namespaces.length);
			
			if (index == 0) return "*";
			return _constants.strings[namespaces[index].name];
		}
		
		/**
		 * 获取multiname
		 * @param index	执行multinames常量数组的索引
		 * @return 字符串
		 */		
		private function getName(index:uint):String
		{
			var multinames:Vector.<MultinameInfo> = _constants.multinames;
			assertTrue(index >= 0 && index < multinames.length);
		
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_code = "";
			
			var label:LabelMgr = new LabelMgr();
			
			var item:String, opcode:uint;			
			while (decoder.bytesAvailable)
			{
				item = "";
				opcode = decoder.readUI8();
				
				if (opcode == OpcodeType.LABEL_OP || label.has(decoder.position))
				{
					item = label.get(decoder.position) + ":";
				}
				
				item = padding(item, 4, " ", false);
				item += padding(_map[opcode], 16);
				
				switch(opcode)
				{
					case OpcodeType.DEBUG_OP:
					case OpcodeType.PUSHSTRING_OP:
					{
						item += getSTR(decoder.readES30());
						break;
					}
						
					case OpcodeType.PUSHNAMESPACE_OP:
					{
						item += getNS(decoder.readEU30());
						break;
					}
						
					case OpcodeType.PUSHINT_OP:
					{
						item += _constants.ints[decoder.readES30()];
						break;
					}
						
					case OpcodeType.PUSHUINT_OP:
					{
						item += _constants.uints[decoder.readEU30()];
						break;
					}
						
					case OpcodeType.PUSHDOUBLE_OP:
					{
						item += _constants.doubles[decoder.readEU30()];
						break;
					}
					
					case OpcodeType.GETSUPER_OP:
					case OpcodeType.SETSUPER_OP:
					case OpcodeType.GETPROPERTY_OP:
					case OpcodeType.INITPROPERTY_OP:
					case OpcodeType.SETPROPERTY_OP:
					case OpcodeType.GETLEX_OP:
					case OpcodeType.FINDPROPSTRICT_OP:
					case OpcodeType.FINDPROPERTY_OP:
					case OpcodeType.FINDDEF_OP:
					case OpcodeType.DELETEPROPERTY_OP:
					case OpcodeType.ISTYPE_OP:
					case OpcodeType.COERCE_OP:
					case OpcodeType.ASTYPE_OP:
					case OpcodeType.GETDESCENDANTS_OP:
					{
						break;
					}
						
					default:
					{
						break;
					}
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
		 * 已解码的opcode指令
		 */		
		public function get code():String { return _code; }
	}
}
import flash.utils.Dictionary;

class LabelMgr
{
	private var _index:uint;
	private var _map:Dictionary;
	
	/**
	 * 构造函数
	 * create a [OpcodeInfo] object
	 */
	public function LabelMgr()
	{
		_index = 0;
		_map = new Dictionary(false);
	}
	
	/**
	 * 获取JUMP标签
	 * @param offset	字节偏移量
	 * @return 	标签字符串
	 */	
	public function get(offset:uint):String
	{
		if (!_map[offset])
		{
			_map[offset] = "L" + (++_index);
		}
		
		return _map[offset];
	}
	
	/**
	 * 判断某个偏移量的位置是否有JUMP标签
	 * @param offset	字节偏移量
	 * @return 
	 */	
	public function has(offset:uint):Boolean
	{
		return Boolean(_map[offset]);
	}
}