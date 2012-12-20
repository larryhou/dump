package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * DoABC之类信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:46:41 PM
	 */
	public class ScriptInfo implements ICodec
	{
		protected var _initializer:uint;
		protected var _traits:Vector.<TraitInfo>;
		
		protected var _variables:Vector.<TraitInfo>;
		protected var _methods:Vector.<TraitInfo>;
		protected var _classes:Vector.<TraitInfo>;
		
		protected var _abc:DoABC;
		
		/**
		 * 构造函数
		 * create a [ScriptInfo] object
		 */
		public function ScriptInfo(abc:DoABC)
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
			
			var _lenght:uint, i:int;
			
			_lenght = decoder.readEU30();
			_traits = new Vector.<TraitInfo>(_lenght, true);
			for (i = 0; i < _lenght; i++)
			{
				_traits[i] = new TraitInfo(_abc);
				_traits[i].decode(decoder);
				
				// 特征归类
				switch (_traits[i].kind)
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
					}
						
					default:
					{
						if (!_variables) _variables = new Vector.<TraitInfo>;
						_variables.push(_traits[i]);
						break;
					}
				}

			}
			
			trace(this);
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
			return "script:[Trait]" + _traits.join("\n       [Trait]");
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
	}
}