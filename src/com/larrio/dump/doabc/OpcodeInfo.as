package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.dump.utils.hexSTR;
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
		
		private var _abc:DoABC;
		private var _constants:ConstantPool;
		
		private var _method:uint;
		private var _closures:Vector.<uint>;
		
		/**
		 * 构造函数
		 * create a [OpcodeInfo] object
		 */
		public function OpcodeInfo(abc:DoABC)
		{
			_abc = abc;
			_constants = _abc.constants;
			
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
		 */		
		private function getSTR(index:uint):String
		{
			var strings:Vector.<String> = _constants.strings;
			assertTrue(index >= 0 && index < strings.length);
			
			if (index == 0) return '""';
			return '"' + strings[index].replace(/\n/g, "\\n").replace(/\t/g, "\\t") + '"';
		}
		
		/**
		 * 获取命名空间 
		 * @param index	指向namespaces常量数组的索引
		 * @return 字符串
		 */		
		private function namespaceSTR(index:uint):String
		{
			var namespaces:Vector.<NamespaceInfo> = _constants.namespaces;
			assertTrue(index >= 0 && index < namespaces.length);
			
			if (index == 0) return "";
			return namespaces[index].toString();
		}
		
		/**
		 * 获取multiname
		 * @param index	指向multinames常量数组的索引
		 */		
		private function multinameSTR(index:uint):String
		{
			var multinames:Vector.<MultinameInfo> = _constants.multinames;
			assertTrue(index >= 0 && index < multinames.length);
			
			if (index == 0) return "*";
			return multinames[index].toString();
		}
		
		/**
		 * 获取函数名字符串 
		 * @param index 指向methods常量数组的索引
		 */		
		private function methodSTR(index:uint):String
		{
			var methods:Vector.<MethodInfo> = _abc.methods;
			assertTrue(index >= 0 && index < methods.length);
			
			return methods[index].toString();
		}
				
		/**
		 * 获取实例对象名称 
		 * @param index	指向instances数组的索引
		 */		
		private function instanceSTR(index:uint):String
		{
			var instances:Vector.<InstanceInfo> = _abc.instances;
			assertTrue(index >= 0 && index < instances.length);
			
			return _constants.multinames[instances[index].name].toString();
		}
		
		/**
		 * 获取slot特征信息 
		 */		
		private function slotSTR(id:uint):String
		{
			var info:MethodInfo = _abc.methods[_method];
			
			// FIXME: sometimes cannot get slot info
			return (info.body.getTraitAt(id) || id).toString();
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器 
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_code = "";
			
			var startAt:uint;
			var target:uint, pos:uint;
			
			var labels:LabelMgr = new LabelMgr();
			
			var item:String, opcode:uint;			
			while (decoder.bytesAvailable)
			{
				startAt = decoder.position;
				
				item = "";
				opcode = decoder.readUI8();
				
				if (opcode == OpcodeType.LABEL_OP || labels.has(decoder.position - 1))
				{
					item = labels.get(decoder.position - 1) + ":";
				}
				
				item = padding(item, 4, " ", false);
				if (_map[opcode])
				{
					item += padding(_map[opcode], 16);
				}
				
				switch(opcode)
				{
					case OpcodeType.DEBUGFILE_OP:
					case OpcodeType.PUSHSTRING_OP:
					{
						item += getSTR(decoder.readES30());
						break;
					}
						
					case OpcodeType.PUSHNAMESPACE_OP:
					{
						item += namespaceSTR(decoder.readEU30());
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
						item += multinameSTR(decoder.readEU30());
						break;
					}
					
					case OpcodeType.CONSTRUCTPROP_OP:
					case OpcodeType.CALLPROPERTY_OP:
					case OpcodeType.CALLPROPLEX_OP:
					case OpcodeType.CALLSUPER_OP:
					case OpcodeType.CALLSUPERVOID_OP:
					case OpcodeType.CALLPROPVOID_OP:
					{
						item += multinameSTR(decoder.readEU30());
						item += "(" + decoder.readEU30() + ")";
						break;
					}
						
					case OpcodeType.NEWFUNCTION_OP:
					{
						target = decoder.readEU30();
						item += methodSTR(target);
						
						if (!_closures) _closures = new Vector.<uint>;
						
						// 只保存没有名称的闭包函数
						if (_closures.indexOf(target) < 0) _closures.push(target);
						break;
					}
						
					case OpcodeType.CALLSTATIC_OP:
					{
						item += methodSTR(decoder.readEU30());
						item += "(" + decoder.readES30() + ")";
						break;
					}
						
					case OpcodeType.NEWCLASS_OP:
					{
						item += instanceSTR(decoder.readEU30());
						break;
					}
						
					case OpcodeType.LOOKUPSWITCH_OP:
					{
						pos = decoder.position - 1;
						target = pos + decoder.readS24();
						
						var caseCount:uint = decoder.readEU30();
						
						item += "default:" + labels.get(target);
						item += " caseCount:" + caseCount;
						
						for (var i:int = 0; i <= caseCount; i++)
						{
							target = pos + decoder.readS24();
							item += " " + labels.get(target);
						}
						
						break;
					}
						
					case OpcodeType.JUMP_OP:
					case OpcodeType.IFTRUE_OP:		case OpcodeType.IFFALSE_OP:
					case OpcodeType.IFEQ_OP:		case OpcodeType.IFNE_OP:
					case OpcodeType.IFGE_OP:		case OpcodeType.IFNGE_OP:
					case OpcodeType.IFGT_OP:		case OpcodeType.IFNGT_OP:
					case OpcodeType.IFLE_OP:		case OpcodeType.IFNLE_OP:
					case OpcodeType.IFLT_OP:		case OpcodeType.IFNLT_OP:
					case OpcodeType.IFSTRICTEQ_OP:case OpcodeType.IFSTRICTNE_OP:
					{
						var offset:int = decoder.readS24();
						target = decoder.position + offset;
						item += labels.get(target);
						break;
					}
						
					case OpcodeType.INCLOCAL_OP:
					case OpcodeType.DECLOCAL_OP:
					case OpcodeType.INCLOCALI_OP:
					case OpcodeType.DECLOCALI_OP:
					case OpcodeType.GETLOCAL_OP:
					case OpcodeType.SETLOCAL_OP:
					case OpcodeType.KILL_OP:
					case OpcodeType.DEBUGLINE_OP:
					case OpcodeType.GETGLOBALSLOT_OP:
					case OpcodeType.SETGLOBALSLOT_OP:
					case OpcodeType.PUSHSHORT_OP:
					case OpcodeType.NEWCATCH_OP:
					{
						item += decoder.readES30();
						break;
					}
						
					case OpcodeType.GETSLOT_OP:
					case OpcodeType.SETSLOT_OP:
					{
						item += slotSTR(decoder.readEU30());
						break;
					}
						
					case OpcodeType.DEBUG_OP:
					{
						item += decoder.readUI8();
						item += " " + decoder.readEU30();
						item += " " + decoder.readUI8();
						item += " " + decoder.readEU30();
						break;
					}
						
					case OpcodeType.NEWOBJECT_OP:
					{
						item += "{" + decoder.readEU30() + "}";
						break;
					}
						
					case OpcodeType.NEWARRAY_OP:
					{
						item += "[" + decoder.readEU30() + "]";
						break;
					}
						
					case OpcodeType.CALL_OP:
					case OpcodeType.CONSTRUCT_OP:
					case OpcodeType.CONSTRUCTSUPER_OP:
					{
						item += "(" + decoder.readEU30() + ")";
						break;
					}
						
					case OpcodeType.PUSHBYTE_OP:
					case OpcodeType.GETSCOPEOBJECT_OP:
					{
						item += decoder.readUI8();
						break;
					}
						
					case OpcodeType.HASNEXT2_OP:
					{
						item += decoder.readEU30() + " " + decoder.readEU30();
						break;
					}
					
					default:
					{
						break;
					}
						
				}
				
				if (opcode == OpcodeType.LABEL_OP) item = "\n" + item;
				if (labels.has(decoder.position)) item += "\n";
				
				_code += item + "\n";
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
		 * 字符串输出
		 */		
		public function toString():String
		{
			return _code;
		}

		/**
		 * 已解码的opcode指令
		 */		
		public function get code():String { return _code; }

		/**
		 * 方法引用
		 */		
		public function get method():uint { return _method; }
		public function set method(value:uint):void
		{
			_method = value;
		}

		/**
		 * 闭包函数
		 */		
		public function get closures():Vector.<uint> { return _closures; }


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
			_map[offset] = "L" + (_index++);
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