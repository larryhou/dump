package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
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
		
		private var _files:Vector.<ClassFile>;
		
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
				_instances[i] = new InstanceInfo(this);
				_instances[i].decode(decoder);
			}
			
			_classes = new Vector.<ClassInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_classes[i] = new ClassInfo(this);
				_classes[i].instance = _instances[i];
				_classes[i].decode(decoder);
			}
			
			_length = decoder.readEU30();
			_scripts = new Vector.<ScriptInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_scripts[i] = new ScriptInfo(this);
				_scripts[i].decode(decoder);
			}
			
			_length = decoder.readEU30();
			_methodBodies = new Vector.<MethodBodyInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_methodBodies[i] = new MethodBodyInfo(this);
				_methodBodies[i].decode(decoder);
			}
			
			_length = _scripts.length;
			_files = new Vector.<ClassFile>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_files[i] = new ClassFile(_scripts[i], this);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:uint, i:int;
			
			encoder.writeUI16(_minorVersion);
			encoder.writeUI16(_majorVersion);
			
			_constants.encode(encoder);
			
			length = _methods.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_methods[i].encode(encoder);
			}
			
			length = _metadatas.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_metadatas[i].encode(encoder);
			}
			
			length = _instances.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_instances[i].encode(encoder);
			}
			
			length = _classes.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_classes[i].encode(encoder);
			}
			
			length = _scripts.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_scripts[i].encode(encoder);
			}
			
			length = _methodBodies.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_methodBodies[i].encode(encoder);
			}
		}

		/**
		 * 大版本号
		 */		
		public function get majorVersion():uint { return _majorVersion; }

		/**
		 * 小版本号
		 */		
		public function get minorVersion():uint { return _minorVersion; }

		/**
		 * 常量池
		 */		
		public function get constants():ConstantPool { return _constants; }

		/**
		 * 函数信息
		 */		
		public function get methods():Vector.<MethodInfo> { return _methods; }

		/**
		 * 类方法bytecode实体
		 */		
		public function get methodBodies():Vector.<MethodBodyInfo> { return _methodBodies; }

		/**
		 * metadata
		 */		
		public function get metadatas():Vector.<MetadataInfo> { return _metadatas; }

		/**
		 * 对应类定义声明的成员变量
		 */		
		public function get instances():Vector.<InstanceInfo> { return _instances; }

		/**
		 * 类定义
		 */		
		public function get classes():Vector.<ClassInfo> { return _classes; }

		/**
		 * scripts
		 */		
		public function get scripts():Vector.<ScriptInfo> { return _scripts; }

		/**
		 * 类文件
		 */		
		public function get files():Vector.<ClassFile> { return _files; }

	}
}