package com.larrio.dump.encrypt
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.dump.encrypt.collectors.ClassCollector;
	import com.larrio.dump.encrypt.collectors.TypeCollector;
	import com.larrio.dump.encrypt.core.KeyChain;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.SymbolClassTag;
	import com.larrio.dump.tags.TagType;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 23, 2013 11:38:32 PM
	 */
	public class FileEncryptor
	{
		private var _typeCollector:TypeCollector;
		private var _classCollector:ClassCollector;
		
		private var _keys:KeyChain;
		private var _files:Vector.<SWFile>;
		
		private var _messages:Array;
		
		/**
		 * 构造函数
		 * create a [FileEncryptor] object
		 */
		public function FileEncryptor()
		{
			_typeCollector = new TypeCollector();
			_classCollector = new ClassCollector();
			
			_keys = new KeyChain();
			_files = new Vector.<SWFile>;
			
			_messages = [];
		}
		
		/**
		 * 添加SWF文件 
		 * @param swf SWFile对象
		 */	
		public function pushSWF(swf:SWFile):void
		{
			_files.push(swf);
			_typeCollector.collect(swf);
			_classCollector.collect(swf);
		}
		
		/**
		 * 执行加密逻辑 
		 * @param settings	加密配置
		 * @return 项目加密配置
		 */		
		public function encrypt(settings:XML = null):XML
		{
			_keys.settings = settings;
			_keys.createKeys(_typeCollector, _classCollector);		
			
			for each(var swf:SWFile in _files) processFile(swf);
			
			return _keys.settings;	
		}
		
		private function processFile(swf:SWFile):void
		{
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC)
				{
					processABC((tag as DoABCTag).abc);
				}
				else
				if (tag.type == TagType.SYMBOL_CLASS)
				{
					processSymbolTag(tag as SymbolClassTag);
				}
			}
		}
		
		private function processSymbolTag(symbolTag:SymbolClassTag):void
		{
			var name:String, key:String;
			for (var i:int = 0; i < symbolTag.ids.length; i++)
			{
				if (symbolTag.ids[i] == 0)
				{
					name = symbolTag.symbols[i];
					name = name.replace(/\.([^\.]+)$/, ":$1");
					
					key = _keys.getKey(name);
					if (key)
					{
						key = key.replace(/:(.+)$/, ".$1");
						symbolTag.symbols[i] = key;
						
						record(name, key);
					}
					
					break;
				}
			}
		}
		
		private function processABC(abc:DoABC):void
		{
			var name:String, key:String;
			var list:Vector.<String> = abc.constants.strings;
			for (var i:int = 0, length:uint = list.length; i < length; i++)
			{
				name = list[i];
				key = _keys.getKey(name);
				if (key)
				{
					list[i] = key;
					record(name, key);
				}
			}
		}
		
		private function record(name:String, key:String):void
		{
			_messages.push([name, key]);
		}
		
		/**
		 * 打印加密log
		 */		
		public function get log():String
		{
			var indent:uint = 0;
			
			var name:String;
			var i:uint, length:uint;
			for (i = 0, length = _messages.length; i < length; i++)
			{
				name = _messages[i][0];
				indent = Math.max(name.length, indent);
			}
			
			indent += 2;
			
			var result:String = "";
			for (i = 0; i < length; i++)
			{
				name = _messages[i][0];
				while (name.length < indent) name += "-";
				result += name + _messages[i][1] + "\n";
			}
			
			return result;
		}

		/**
		 * 加密串管理器
		 */		
		public function get keys():KeyChain { return _keys; }

	}
}