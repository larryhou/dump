package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 可选传参详细信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 6:43:27 PM
	 */
	public class OptionInfo implements ICodec
	{
		private var _index:uint;
		private var _kind:uint;
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [OptionInfo] object
		 */
		public function OptionInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_index = decoder.readEU30();
			_kind = decoder.readUI8();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeEU30(_index);
			encoder.writeUI8(_kind);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:String = "";
			
			switch (_kind)
			{
				case OptionKindType.INT:
				{
					result += _constants.ints[_index];
					break;
				}
					
				case OptionKindType.UINT:
				{
					result += _constants.uints[_index];
					break;
				}
					
				case OptionKindType.DOUBLE:
				{
					result += _constants.doubles[_index];
					break;
				}
					
				case OptionKindType.UTF8:
				{
					result += _constants.strings[_index];
					break;
				}
					
				case OptionKindType.TRUE:
				{
					result += "true";
					break;
				}
					
				case OptionKindType.FALSE:
				{
					result += "false";
					break;
				}
					
				case OptionKindType.NULL:
				{
					result += "null";
					break;
				}
					
				case OptionKindType.UNDEFINED:
				{
					result += "undefined";
					break;
				}
					
				default:
				{
					result += _constants.namespaces[_index];
					break;
				}
			}
			
			return result;
		}
		
		/**
		 * 指向常量池某个数组的索引值 
		 */		
		public function get index():uint { return _index; }
		
		/**
		 * 该属性确定了value具体指向哪个常量数组 
		 * @return 
		 * 
		 */		
		public function get kind():uint { return _kind; }
		
	}
}