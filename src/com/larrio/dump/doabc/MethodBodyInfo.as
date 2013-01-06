package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * DoABC之函数体
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:43:45 PM
	 */
	public class MethodBodyInfo implements ICodec
	{
		private var _method:uint;
		
		private var _maxStack:uint;
		
		private var _localCount:uint;
		
		private var _initScopeDepth:uint;
		private var _maxScopeDepth:uint;
		
		private var _code:ByteArray;
		private var _opcode:OpcodeInfo;
		
		private var _exceptions:Vector.<ExceptionInfo>;
		private var _traits:Vector.<TraitInfo>;
		
		private var _abc:DoABC;
		
		private var _slots:Dictionary;
		
		private var _timestamp:uint;
		
		/**
		 * 构造函数
		 * create a [MethodBodyInfo] object
		 */
		public function MethodBodyInfo(abc:DoABC)
		{
			_abc = abc;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_method = decoder.readEU30();
			
			// 设置函数体
			_abc.methods[_method].body = this;
			
			_maxStack = decoder.readEU30();
			
			_localCount = decoder.readEU30();
			
			_initScopeDepth = decoder.readEU30();
			_maxScopeDepth = decoder.readEU30();
			
			var _length:uint, i:int;
			
			_length = decoder.readEU30();
			
			_code = new ByteArray();
			decoder.readBytes(_code, 0, _length);
			_code.position = 0;
			
			_length = decoder.readEU30();
			_exceptions = new Vector.<ExceptionInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_exceptions[i] = new ExceptionInfo(_abc.constants);
				_exceptions[i].decode(decoder);
			}
			
			_slots = new Dictionary(false);
			
			_length = decoder.readEU30();
			_traits = new Vector.<TraitInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_traits[i] = new TraitInfo(_abc);
				_traits[i].decode(decoder);
				
				_slots[_traits[i].data.id] = _traits[i];
			}
			
			// decode opcode
			decoder = new FileDecoder();
			decoder.writeBytes(_code);
			decoder.position = 0;
			
			_opcode = new OpcodeInfo(_abc);
			_opcode.method = _method;
			
			_opcode.decode(decoder);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:uint, i:int;
			
			encoder.writeEU30(_method);
			
			encoder.writeEU30(_maxStack);
			encoder.writeEU30(_localCount);
			
			encoder.writeEU30(_initScopeDepth);
			encoder.writeEU30(_maxScopeDepth);
			
			length = _code.length;
			encoder.writeEU30(length);
			encoder.writeBytes(_code);
			
			length = _exceptions.length;
			encoder.writeEU30(length);
			
			for (i = 0; i < length; i++)
			{
				_exceptions[i].encode(encoder);
			}
			
			length = _traits.length;
			encoder.writeEU30(length);
			
			for (i = 0; i < length; i++)
			{
				_traits[i].encode(encoder);
			}
		}
		
		/**
		 * 获取某个slot位置的特征属性 
		 * @param slot 
		 */		
		public function getTraitAt(slot:uint):TraitInfo
		{
			return _slots[slot];
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString(time:uint = 0):String
		{
			_timestamp = time || getTimer();
			
			var i:int;
			var result:String = "";
			result += "    maxStack:" + _maxStack + " localCount:" + _localCount + " initScopeDepth:" + _initScopeDepth + " maxScopeDepth:" + _maxScopeDepth;
			result += "\n" + _opcode.toString();
			
			if (_opcode.closures)
			{
				var body:MethodBodyInfo;
				for (i = 0; i < _opcode.closures.length; i++)
				{
					body = _abc.methodBodies[_opcode.closures[i]];
					if (body._timestamp != _timestamp)
					{
						result += "\n" + _abc.methods[_opcode.closures[i]];
						result += "\n" + body.toString(_timestamp);
					}
				}
			}
			
			return result;
		}

		/**
		 * 指向methods数组的索引
		 */		
		public function get method():uint { return _method; }

		/**
		 * max stack
		 */		
		public function get maxStack():uint { return _maxStack; }

		/**
		 * 局部变量变量数量
		 */		
		public function get localCount():uint { return _localCount; }

		/**
		 * init scope depth
		 */		
		public function get initScopeDepth():uint { return _initScopeDepth; }

		/**
		 * max scope depth
		 */		
		public function get maxScopeDepth():uint { return _maxScopeDepth; }

		/**
		 * 代码
		 */		
		public function get opcode():OpcodeInfo { return _opcode; }

		/**
		 * exception
		 */		
		public function get exceptions():Vector.<ExceptionInfo> { return _exceptions; }

		/**
		 * 函数特征
		 */		
		public function get traits():Vector.<TraitInfo> { return _traits; }

	}
}