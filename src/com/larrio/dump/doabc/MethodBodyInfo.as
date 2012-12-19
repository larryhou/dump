package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	import flash.utils.ByteArray;
	
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
		
		private var _exceptions:Vector.<ExceptionInfo>;
		private var _traits:Vector.<TraitInfo>;
		
		private var _abc:DoABC;
		
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
			
			_maxStack = decoder.readEU30();
			
			_localCount = decoder.readEU30();
			
			_initScopeDepth = decoder.readEU30();
			_maxScopeDepth = decoder.readEU30();
			
			var _length:uint, i:int;
			
			_length = decoder.readEU30();
			
			_code = new ByteArray();
			decoder.readBytes(_code,0, _length);
			_code.position = 0;
			
			_length = decoder.readEU30();
			_exceptions = new Vector.<ExceptionInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_exceptions[i] = new ExceptionInfo(_abc.constants);
				_exceptions[i].decode(decoder);
			}
			
			_length = decoder.readEU30();
			_traits = new Vector.<TraitInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_traits[i] = new TraitInfo(_abc);
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
	}
}