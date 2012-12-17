package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * DoABC之实例信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:43:17 PM
	 */
	public class InstanceInfo implements ICodec
	{
		private var _name:uint;
		private var _superName:uint;
		
		private var _flags:uint;
		private var _protectedNS:uint;
		
		private var _interfaces:Vector.<uint>;
		
		private var _initializer:uint;
		
		private var _traits:Vector.<TraitInfo>;
		
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [InstanceInfo] object
		 */
		public function InstanceInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_name = decoder.readEU30();
			_superName = decoder.readEU30();
			
			_flags = decoder.readUI8();
			if ((_flags & InstanceType.CLASS_PROTECTED_NS) == InstanceType.CLASS_PROTECTED_NS)
			{
				_protectedNS = decoder.readEU30();
			}
			
			var _length:uint, i:int;
			
			_length = decoder.readEU30();
			_interfaces = new Vector.<uint>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_interfaces[i] = decoder.readEU30();
			}
			
			_initializer = decoder.readEU30();
			
			_length = decoder.readES30();
			_traits = new Vector.<TraitInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_traits[i] = new TraitInfo(_constants);
				_traits[i].decode(decoder);
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
		 * 指向multinames常量数组的索引
		 */		
		public function get name():uint { return _name; }

		/**
		 * 指向multinames常量数组的索引
		 */		
		public function get superName():uint { return _superName; }

		/**
		 * 标记位
		 */		
		public function get flags():uint { return _flags; }

		/**
		 * 指向namespaces常量数组的索引，仅当flags == InstanceType.CLASS_PROTECTED_NS有效
		 * 
		 */		
		public function get protectedNS():uint { return _protectedNS; }
		
		/**
		 * 指向multinames常量数组的索引
		 */		
		public function get interfaces():Vector.<uint> { return _interfaces; }

		/**
		 * 指向methods数组的索引
		 */		
		public function get initializer():uint { return _initializer; }

		/**
		 * 实例特征信息数组
		 */		
		public function get traits():Vector.<TraitInfo> { return _traits; }


	}
}