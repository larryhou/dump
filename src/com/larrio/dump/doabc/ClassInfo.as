package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.interfaces.IScript;
	
	import flash.utils.Dictionary;
	
	/**
	 * DoABC之类信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:46:41 PM
	 */
	public class ClassInfo extends ScriptNode implements ICodec
	{
		private var _initializer:uint;
		private var _traits:Vector.<TraitInfo>;
		
		private var _instance:InstanceInfo;
		private var _abc:DoABC;
		
		/**
		 * 构造函数
		 * create a [ClassInfo] object
		 */
		public function ClassInfo(abc:DoABC)
		{
			_abc = abc;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_initializer = decoder.readEU30();
			
			_abc.methods[_initializer].type = MethodType.INITIALIZER;
			_abc.methods[_initializer].belong = this;
			
			var _lenght:uint, i:int;
			
			_lenght = decoder.readEU30();
			_traits = new Vector.<TraitInfo>(_lenght, true);
			for (i = 0; i < _lenght; i++)
			{
				_traits[i] = new TraitInfo(_abc);
				_traits[i].decode(decoder);
				
				if (addTrait(_traits[i]))
				{
					_abc.methods[_traits[i].data.method].belong = this;
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
			
			encoder.writeEU30(_initializer);
			
			length = _traits.length;
			encoder.writeEU30(length);
			
			for (i = 0; i < length; i++)
			{
				_traits[i].encode(encoder);
			}			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:String = "class:";
			result += _abc.constants.multinames[_instance.name];
			
			var indent:String = "      ";
			if (_traits.length) result += "\n" + indent + "[Trait]" + _traits.join("\n" + indent + "[Trait]");
			return result;
		}


		/**
		 * 指向methods数组的索引
		 * static initializer for class
		 */		
		public function get initializer():uint { return _initializer; }

		/**
		 * 特征信息
		 */		
		public function get traits():Vector.<TraitInfo> { return _traits; }
		
		/**
		 * class对应instance
		 */		
		public function get instance():InstanceInfo { return _instance; }
		public function set instance(value:InstanceInfo):void
		{
			_instance = value;
			_instance.belong = this;
		}
		
	}
}