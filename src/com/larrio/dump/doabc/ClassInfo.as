package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * DoABC之类信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:46:41 PM
	 */
	public class ClassInfo implements ICodec
	{
		protected var _initializer:uint;
		protected var _traits:Vector.<TraitInfo>;
		
		protected var _variables:Vector.<TraitInfo>;
		protected var _methods:Vector.<TraitInfo>;
		protected var _classes:Vector.<TraitInfo>;
		
		protected var _instance:InstanceInfo;
		
		protected var _abc:DoABC;
		
		private var _lenR:uint;
		
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
			_lenR = decoder.position;
			_initializer = decoder.readEU30();
			
			var _lenght:uint, i:int;
			
			_lenght = decoder.readEU30();
			_traits = new Vector.<TraitInfo>(_lenght, true);
			for (i = 0; i < _lenght; i++)
			{
				_traits[i] = new TraitInfo(_abc);
				_traits[i].decode(decoder);
				
				// 特征归类
				switch (_traits[i].kind & 0xF)
				{
					case TraitType.GETTER:
					case TraitType.SETTER:
					case TraitType.METHOD:
					case TraitType.FUNCTION:
					{
						if (!_methods) _methods = new Vector.<TraitInfo>;
						_methods.push(_traits[i]);
						break;
					}
					
					case TraitType.CLASS:
					{
						if (!_classes) _classes = new Vector.<TraitInfo>;
						_classes.push(_traits[i]);
						break;
					}
						
					default:
					{
						if (!_variables) _variables = new Vector.<TraitInfo>;
						_variables.push(_traits[i]);
						break;
					}
				}

			}
			
			_lenR = decoder.position - _lenR;
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var lenR:uint = encoder.position;
			var length:uint, i:int;
			
			encoder.writeEU30(_initializer);
			
			length = _traits.length;
			encoder.writeEU30(length);
			
			for (i = 0; i < length; i++)
			{
				_traits[i].encode(encoder);
			}
			
			lenR = encoder.position - lenR;
			assertTrue(lenR == _lenR);
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
		 * 全局变量特征信息
		 */		
		public function get variables():Vector.<TraitInfo> { return _variables; }

		/**
		 * 方法特征信息
		 */		
		public function get methods():Vector.<TraitInfo> { return _methods; }

		/**
		 * 类特征信息
		 */		
		public function get classes():Vector.<TraitInfo> { return _classes; }
		
		/**
		 * class对应instance
		 */		
		public function get instance():InstanceInfo { return _instance; }
		public function set instance(value:InstanceInfo):void
		{
			_instance = value;
		}

	}
}