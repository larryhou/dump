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
		
		private var _enOffset:OffsetMgr;
		private var _deOffset:OffsetMgr;
		
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
			_deOffset = new OffsetMgr(decoder.position);
			
			_minorVersion = decoder.readUI16();
			assertTrue(_minorVersion == 16);
				
			_majorVersion = decoder.readUI16();
			assertTrue(_majorVersion == 46);
			
			_deOffset.set(this, decoder.position);
			
			_constants = new ConstantPool();
			_constants.decode(decoder);
			
			_deOffset.set(_constants, decoder.position);
			
			var _length:uint, i:int;
			
			_length = decoder.readEU30();
			_methods = new Vector.<MethodInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_methods[i] = new MethodInfo(_constants);
				_methods[i].decode(decoder);
				_methods[i].id = i;
			}
			
			_deOffset.set(_methods, decoder.position);
			
			_length = decoder.readEU30();
			_metadatas = new Vector.<MetadataInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_metadatas[i] = new MetadataInfo(_constants);
				_metadatas[i].decode(decoder);
			}
			
			_deOffset.set(_metadatas, decoder.position);
			
			_length = decoder.readEU30();
			_instances = new Vector.<InstanceInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_instances[i] = new InstanceInfo(this);
				_instances[i].decode(decoder);
			}
			
			_deOffset.set(_instances, decoder.position);
			
			_classes = new Vector.<ClassInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_classes[i] = new ClassInfo(this);
				_classes[i].instance = _instances[i];
				_classes[i].decode(decoder);
			}
			
			_deOffset.set(_classes, decoder.position);
			
			_length = decoder.readEU30();
			_scripts = new Vector.<ScriptInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_scripts[i] = new ScriptInfo(this);
				_scripts[i].decode(decoder);
			}
			
			_deOffset.set(_scripts, decoder.position);
			
			_length = decoder.readEU30();
			_methodBodies = new Vector.<MethodBodyInfo>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_methodBodies[i] = new MethodBodyInfo(this);
				_methodBodies[i].decode(decoder);
			}
			
			_deOffset.set(_methodBodies, decoder.position);
			
			_length = _scripts.length;
			_files = new Vector.<ClassFile>(_length, true);
			for (i = 0; i < _length; i++)
			{
				_files[i] = new ClassFile(_scripts[i], this);
			}
			
			assertTrue(decoder.bytesAvailable == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:uint, i:int;
			
			_enOffset = new OffsetMgr(encoder.position);
			
			encoder.writeUI16(_minorVersion);
			encoder.writeUI16(_majorVersion);
			
			_enOffset.set(this, encoder.position);
			
			_constants.encode(encoder);
			
			_enOffset.set(_constants, encoder.position);
			
			length = _methods.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_methods[i].encode(encoder);
			}
			
			_enOffset.set(_methods, encoder.position);
			
			length = _metadatas.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_metadatas[i].encode(encoder);
			}
			
			_enOffset.set(_metadatas, encoder.position);
			
			length = _instances.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_instances[i].encode(encoder);
			}
			
			_enOffset.set(_instances, encoder.position);
			
			for (i = 0; i < length; i++)
			{
				_classes[i].encode(encoder);
			}
			
			_enOffset.set(_classes, encoder.position);
			
			length = _scripts.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_scripts[i].encode(encoder);
			}
			
			_enOffset.set(_scripts, encoder.position);
			
			length = _methodBodies.length;
			encoder.writeEU30(length);
			for (i = 0; i < length; i++)
			{
				_methodBodies[i].encode(encoder);
			}
			
			_enOffset.set(_methodBodies, encoder.position);
			
			//assertTrue(_enOffset.equals(_deOffset));
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
import flash.utils.Dictionary;

class OffsetMgr
{
	private var _manager:Dictionary;
	private var _offset:uint;
	
	public function OffsetMgr(offset:uint)
	{
		_offset = offset;
		_manager = new Dictionary(false);
	}
	
	public function equals(offset:OffsetMgr):Boolean
	{
		for (var key:Object in offset)
		{
			//if (!_manager[key]) continue;
			
			if (get(key) != offset.get(key)) return false;
		}
		
		return true;
	}
	
	public function set(target:Object, position:uint):void
	{
		_manager[target] = position - _offset;
	}
	
	public function get(target:Object):uint
	{
		return parseInt(_manager[target]);
	}
}