package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 函数特征信息
	 * @author larryhou
	 * @createTime Dec 17, 2012 9:54:37 AM
	 */
	public class TraitInfo implements ICodec
	{
		private var _name:uint;
		private var _kind:uint;
		
		private var _data:TraitDataInfo;
		
		private var _metadatas:Vector.<uint>;
		
		private var _abc:DoABC;
		
		/**
		 * 构造函数
		 * create a [TraitInfo] object
		 */
		public function TraitInfo(abc:DoABC)
		{
			_abc = abc;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_name = decoder.readEU30();
			_kind = decoder.readUI8();
			
			_data = new TraitDataInfo();
			switch (_kind & 0xF)
			{
				case TraitType.SLOT:
				case TraitType.CONST:
				{
					_data.id = decoder.readEU30();
					_data.type = decoder.readEU30();
					_data.index = decoder.readEU30();
					if (_data.index)
					{
						_data.kind = decoder.readUI8();
					}
					
					break;
				}
					
				case TraitType.CLASS:
				{
					_data.id = decoder.readEU30();
					_data.classi = decoder.readEU30();
					break;
				}
					
				default:
				{
					_data.id = decoder.readEU30();
					_data.method = decoder.readEU30();
					
					// 设置函数特征信息
					_abc.methods[_data.method].trait = this;
					break;
				}
			}
			
			var _length:uint, i:int;
			if (((_kind >> 4) & TraitAttriType.METADATA) == TraitAttriType.METADATA)
			{
				_length = decoder.readEU30();
				_metadatas = new Vector.<uint>(_length, true);
				for (i = 0; i < _length; i++)
				{
					_metadatas[i] = decoder.readEU30();
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
			
			encoder.writeEU30(_name);
			encoder.writeUI8(_kind);
			
			switch (_kind & 0xF)
			{
				case TraitType.SLOT:
				case TraitType.CONST:
				{
					encoder.writeEU30(_data.id);
					encoder.writeEU30(_data.type);
					encoder.writeEU30(_data.index);
					if (_data.index)
					{
						encoder.writeUI8(_data.kind);
					}
					break;
				}
					
				case TraitType.CLASS:
				{
					encoder.writeEU30(_data.id);
					encoder.writeEU30(_data.classi);
					break;
				}
					
				default:
				{
					encoder.writeEU30(_data.id);
					encoder.writeEU30(_data.method);
					break;
				}
			}
			
			if (((_kind >> 4) & TraitAttriType.METADATA) == TraitAttriType.METADATA)
			{
				length = _metadatas.length;
				
				encoder.writeEU30(length);
				for (i = 0; i < length; i++)
				{
					encoder.writeEU30(_metadatas[i]);
				}
			}
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:String;
			var multiname:MultinameInfo = _abc.constants.multinames[_name];
			var ns:NamespaceInfo = _abc.constants.namespaces[multiname.ns];
			
			var target:String = _abc.constants.strings[multiname.name];
			
			switch (ns.kind)
			{
				case NSKindType.PRIVATE_NS:
				{
					result = "private";
					break;
				}
					
				case NSKindType.PACKAGE_INTERNAL_NS:
				{
					result = "internal";
					break;
				}
					
				case NSKindType.PROTECTED_NAMESPACE:
				{
					result = "protected";
					break;
				}
					
				case NSKindType.STATIC_PROTECTED_NS:
				{
					result = "protected";
					break;
				}
					
				case NSKindType.PACKAGE_NAMESPACE:
				{
					result = "public";
					break;
				}
			}	
			
			result += " ";
			switch (_kind & 0xF)
			{
				case TraitType.SLOT:
				{
					result += "var " + target + ":" + (_abc.constants.multinames[_data.type] || "*");
					break;
				}
					
				case TraitType.CONST:
				{
					result += "const " + target + ":" + (_abc.constants.multinames[_data.type] || "*");
					break;
				}
				
				case TraitType.CLASS:
				{
					result += target + ":Class";
					break;
				}
					
				case TraitType.GETTER:
				{
					result += "function get " + target;
					break;
				}
					
				case TraitType.SETTER:
				{
					result += "function set " + target;
					break;
				}
					
				default:
				{
					result += "function " + target;
					break;
				}
			}
			
			return result;
		}

		/**
		 * 特征名称
		 */		
		public function get name():uint { return _name; }

		/**
		 * 特征类型
		 */		
		public function get kind():uint { return _kind; }

		/**
		 * 变长度特征信息数据
		 */		
		public function get data():TraitDataInfo { return _data; }

		/**
		 * 特征元数据
		 */		
		public function get metadatas():Vector.<uint> { return _metadatas; }


	}
}