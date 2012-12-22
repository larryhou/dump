package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * DoABC之metadata
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:42:46 PM
	 */
	public class MetadataInfo implements ICodec
	{
		private var _name:uint;
		private var _items:Vector.<MetadataItemInfo>;
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [MetadataInfo] object
		 */
		public function MetadataInfo(constants:ConstantPool)
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
			
			_name = decoder.readEU30();
			assertTrue(_name >= 0 && _name < _constants.strings.length);
			
			_length = decoder.readEU30();
			_items = new Vector.<MetadataItemInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_items[i] = new MetadataItemInfo();
				_items[i].key = decoder.readEU30();
			}	
			
			for (i = 0; i < _length; i++)
			{
				_items[i].value = decoder.readEU30();
			}
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeEU30(_name);
			
			var length:uint, i:int;
			
			length = _items.length;
			encoder.writeEU30(length);
			
			for (i = 0; i < length; i++)
			{
				encoder.writeEU30(_items[i].key);
			}
			
			for (i = 0; i < length; i++)
			{
				encoder.writeEU30(_items[i].value);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var list:Array = [];
			var length:uint = _items.length;
			
			for (var i:int = 0; i < length; i++)
			{
				list.push(_constants.strings[_items[i].key] + '="' + _constants.strings[_items[i].value] + '"');
			}
			
			return "[" + _constants.strings[_name] + "(" + list.join(", ") + ")]";
		}
		
		/**
		 * 指向strings常量数组的索引
		 */		
		public function get name():uint { return _name; }
		
		/**
		 * 指向strings常量数组的索引
		 */		
		public function get items():Vector.<MetadataItemInfo> { return _items; }
		
	}
}