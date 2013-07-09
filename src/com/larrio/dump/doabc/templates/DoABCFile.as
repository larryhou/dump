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
		 * @param value	目标类名 [com.package]::[className]
		 */		
		protected function rename(value:String,indice:Array):void
		{
			value = value.replace(/^\s*|\s*$/g, "");
			if (!_tag || !value) return;
			
			var prefix:String = "";
			var list:Array = value.split("::");
			if (list.length == 2)
			{
				prefix = list.shift();
			}
			
			var className:String = list.pop();
			var qualifiedClassName:String = prefix + ":" + className;
			
			var strings:Vector.<String> = _tag.abc.constants.strings;
			strings[indice[0]] = prefix;
			strings[indice[1]] = className;
			strings[indice[2]] = qualifiedClassName;
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