package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * DoABC之类信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:46:41 PM
	 */
	public class ClassInfo implements ICodec
	{
		protected var _initializer:uint;
		protected var _traits:Vector.<TraitInfo>;
		
		protected var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [ClassInfo] object
		 */
		public function ClassInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_initializer = decoder.readEU30();
			
			var _lenght:uint, i:int;
			
			_lenght = decoder.readEU30();
			_traits = new Vector.<TraitInfo>(_lenght, true);
			for (i = 0; i < _lenght; i++)
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
		 * 指向methods数组的索引
		 * static initializer for class
		 */		
		public function get initializer():uint { return _initializer; }

		/**
		 * 类特征信息
		 */		
		public function get traits():Vector.<TraitInfo> { return _traits; }

	}
}