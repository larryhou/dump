package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * DoABC常量集合
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:11:50 PM
	 */
	public class ConstantPool implements ICodec
	{
		private var _ints:Vector.<int>;
		private var _uints:Vector.<uint>;
		private var _doubles:Vector.<Number>;
		private var _strings:Vector.<String>;
		
		private var _nssets:Vector.<NamespaceSetInfo>;
		private var _namespaces:Vector.<NamespaceInfo>;
		
		private var _multinames:Vector.<MultinameInfo>;
		
		/**
		 * 构造函数
		 * create a [ConstantPool] object
		 */
		public function ConstantPool()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var length:int, i:int;
			
			length = decoder.readEU30();
			_ints = new Vector.<int>(length, true);
			for (i = 1; i < length; i++)
			{
				_ints[i] = decoder.readES32();
			}
			
			length = decoder.readEU30();
			_uints = new Vector.<uint>(length, true);
			for (i = 1; i < length; i++)
			{
				_uints[i] = decoder.readEU32();
			}
			
			length = decoder.readEU30();
			_doubles = new Vector.<Number>(length, true);
			for (i = 1; i < length; i++)
			{
				_doubles[i] = decoder.readDouble();
			}
			
			length = decoder.readEU30();
			_strings = new Vector.<String>(length, true);
			for (i = 1; i < length; i++)
			{
				_strings[i] = decoder.readUTFBytes(decoder.readEU30());
			}
			
			length = decoder.readEU30();
			_namespaces = new Vector.<NamespaceInfo>(length, true);
			for (i = 1; i < length; i++)
			{
				_namespaces[i] = new NamespaceInfo(this);
				_namespaces[i].decode(decoder);
			}
			
			length = decoder.readEU30();
			_nssets = new Vector.<NamespaceSetInfo>(length, true);
			for (i = 1; i < length; i++)
			{
				_nssets[i] = new NamespaceSetInfo(this);
				_nssets[i].decode(decoder);
			}
			
			length = decoder.readEU30();
			_multinames = new Vector.<MultinameInfo>(length, true);
			for (i = 1; i < length; i++)
			{
				_multinames[i] = new MultinameInfo(this);
				_multinames[i].decode(decoder);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var bytes:ByteArray;
			var length:uint, i:int;
			
			length = _ints.length;
			encoder.writeEU30(length);
			for (i = 1; i < length; i++)
			{
				encoder.writeES32(_ints[i]);
			}
			
			length = _uints.length;
			encoder.writeEU30(length);
			for (i = 1; i < length; i++)
			{
				encoder.writeEU32(_uints[i]);
			}
			
			length = _doubles.length;
			encoder.writeEU30(length);
			for (i = 1; i < length; i++)
			{
				encoder.writeDouble(_doubles[i]);
			}
			
			length = _strings.length;
			encoder.writeEU30(length);
			for (i = 1; i < length; i++)
			{
				bytes = new ByteArray();
				bytes.writeUTFBytes(_strings[i]);
				
				encoder.writeEU30(bytes.length);
				encoder.writeBytes(bytes);
			}
			
			length = _namespaces.length;
			encoder.writeEU30(length);
			for (i = 1; i < length; i++)
			{
				_namespaces[i].encode(encoder);
			}
			
			length = _nssets.length;
			encoder.writeEU30(length);
			for (i = 1; i < length; i++)
			{
				_nssets[i].encode(encoder);
			}
			
			length = _multinames.length;
			encoder.writeEU30(length);
			for (i = 1; i < length; i++)
			{
				_multinames[i].encode(encoder);
			}
		}

		/**
		 * 有符号整形数组
		 */		
		public function get ints():Vector.<int> { return _ints; }

		/**
		 * 无符号整形数组
		 */		
		public function get uints():Vector.<uint> { return _uints; }

		/**
		 * 双精度浮点型常量数组
		 */		
		public function get doubles():Vector.<Number> { return _doubles; }

		/**
		 * 字符串常量数组
		 */		
		public function get strings():Vector.<String> { return _strings; }

		/**
		 * 命名空间集合数组
		 */		
		public function get nssets():Vector.<NamespaceSetInfo> { return _nssets; }

		/**
		 * 命名空间数组
		 */		
		public function get namespaces():Vector.<NamespaceInfo> { return _namespaces; }
		
		/**
		 * multinames数组
		 */		
		public function get multinames():Vector.<MultinameInfo> { return _multinames; }
		
	}
}