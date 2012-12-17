package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	import com.larrio.utils.assertTrue;
	
	/**
	 * DoABC代码
	 * @author larryhou
	 * @createTime Dec 16, 2012 2:47:56 PM
	 */
	public class DoABC implements ICodec
	{
		private var _majorVersion:uint;
		private var _minorVersion:uint;
		
		private var _constants:ConstantPool;
		
		private var _methods:Vector.<MethodInfo>;
		private var _methodBodies:Vector.<MethodBodyInfo>;
		
		private var _metadatas:Vector.<MetadataInfo>;
		
		private var _instances:Vector.<InstanceInfo>;
		private var _classes:Vector.<ClassInfo>;
		
		private var _scripts:Vector.<ScriptInfo>;
		
		/**
		 * 构造函数
		 * create a [DoABC] object
		 */
		public function DoABC()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_minorVersion = decoder.readUI16();
			assertTrue(_minorVersion == 16);
				
			_majorVersion = decoder.readUI16();
			assertTrue(_majorVersion == 46);
			
			_constants = new ConstantPool();
			_constants.decode(decoder);
			
			var _length:uint, i:int;
			
			_length = decoder.readEU30();
			_methods = new Vector.<MethodInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_methods[i] = new MethodInfo(_constants);
				_methods[i].decode(decoder);
			}
			
			_length = decoder.readEU30();
			_metadatas = new Vector.<MetadataInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_metadatas[i] = new MetadataInfo(_constants);
				_metadatas[i].decode(decoder);
			}
			
			_length = decoder.readEU30();
			_instances = new Vector.<InstanceInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_instances[i] = new InstanceInfo(_constants);
				_instances[i].decode(decoder);
			}
			
			_classes = new Vector.<ClassInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_classes[i] = new ClassInfo(_constants);
				_classes[i].decode(decoder);
			}
			
			_length = decoder.readEU30();
			_scripts = new Vector.<ScriptInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_scripts[i] = new ScriptInfo(_constants);
				_scripts[i].decode(decoder);
			}
			
			_length = decoder.readEU30();
			_methodBodies = new Vector.<MethodBodyInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_methodBodies[i] = new MethodBodyInfo(_constants);
				_methodBodies[i].decode(decoder);
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