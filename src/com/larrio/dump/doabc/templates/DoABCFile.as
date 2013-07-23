package com.larrio.dump.doabc.templates
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 9:41:27 AM
	 */
	public class DoABCFile
	{
		protected var _tag:DoABCTag;
		
		/**
		 * 构造函数
		 * create a [DoABC] object
		 */
		public function DoABCFile()
		{
			
		}
		
		/**
		 * 解析DoABC
		 * @param bytes	DoABC二进制文件	
		 */		
		public final function decodeDoABCTag(bytes:ByteArray):void
		{
			var decoder:FileDecoder = new FileDecoder();
			decoder.writeBytes(bytes);
			decoder.position = 0;
			
			_tag = new DoABCTag();
			_tag.decode(decoder);
		}
		
		/**
		 * 把DoABC打包成二进制文件
		 * @return 二进制数组
		 */		
		public final function encodeDoABCTag():ByteArray
		{
			var encoder:FileEncoder = new FileEncoder();
			_tag.encode(encoder);
			return encoder;
		}
		
		/**
		 * 对导出类重命名
		 * @param value	目标类名 [com.package]::[className] or [com.package].[className]
		 */		
		protected function rename(value:String):void
		{
			value = value.replace(/^\s*|\s*$/g, "");
			
			// check class name
			if (!value || !value.match(/^([^0-9]\w*(\.[^0-9]\w*)*(::|\.))?[^0-9]\w*$/))
			{
				throw new ArgumentError("Invalide class name:" + value);
			}
			
			// standardize class name
			value = value.replace(/\.(\w+)$/, "::$1");
			
			
			var prefix:String = "";
			var list:Array = value.split("::");
			if (list.length == 2)
			{
				prefix = list.shift();
			}
			
			var className:String = list.pop();
			var qualifiedClassName:String = prefix + ":" + className;
			
			_tag.name = prefix.replace(/\./g, "/") + (prefix? "/" : "") + className;
			
			var strings:Vector.<String> = _tag.abc.constants.strings;
			strings[1] = qualifiedClassName;
			strings[2] = "";
			strings[3] = qualifiedClassName + "/" + className;
			strings[4] = prefix;
			strings[5] = className;
		}

		/**
		 * DoABCTag引用
		 */		
		public function get tag():DoABCTag { return _tag; }
		public function set tag(value:DoABCTag):void
		{
			_tag = value;
		}

	}
}