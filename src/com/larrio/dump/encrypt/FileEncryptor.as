package com.larrio.dump.encrypt
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.doabc.ClassInfo;
	import com.larrio.dump.doabc.MultiKindType;
	import com.larrio.dump.doabc.MultinameInfo;
	import com.larrio.dump.doabc.ScriptInfo;
	import com.larrio.dump.doabc.TraitInfo;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.SymbolClassTag;
	import com.larrio.dump.tags.TagType;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.Dictionary;
	
	/**
	 * SWF代码加密器
	 * @author larryhou
	 * @createTime Dec 22, 2012 8:19:10 PM
	 */
	public class FileEncryptor
	{
		private var _files:Vector.<SWFile>;
		private var _queue:Vector.<EncryptItem>;
		
		private var _names:Vector.<String>;
		
		private var _map:Dictionary;
		private var _reverse:Dictionary;
		
		private var _include:Dictionary;
		private var _exclude:Dictionary;
		
		/**
		 * 构造函数
		 * create a [FileEncryptor] object
		 */
		public function FileEncryptor()
		{
			_files = new Vector.<SWFile>;
			
			_names = new Vector.<String>;
			_queue = new Vector.<EncryptItem>;
			
			_map = new Dictionary(true);
			_reverse = new Dictionary(true);
			
			_include = new Dictionary(true);
			_exclude = new Dictionary(true);
		}
		
		/**
		 * 文件添加完成后调用此方法进行加密处理 
		 */		
		public function encrypt(settings:XML = null):XML
		{
			importConfig(settings);
			
			var item:EncryptItem;
			var length:uint, i:int;
			
			for each(item in _queue)
			{
				setup(item.classes, item.strings);
				setup(item.packages, item.strings);
			}
			
			// 按照字符串从长到短排列
			_names.sort(function(s1:String, s2:String):int
			{
				return s1.length > s2.length? -1 : 1;
			});
			
			var name:String;
			for each(item in _queue)
			{
				item.tag.modified = true;
				replace(item.strings, 1);
			}
			
			var symbol:SymbolClassTag;
			for (i = 0; i < _files.length; i++)
			{
				symbol = _files[i].symbol;
				if (!symbol) continue;
				
				symbol.modified = true;
				replace(symbol.symbols);
			}
			
			return exportConfig();
		}
		
		// 初始化加密key
		private function setup(refers:Vector.<uint>, strings:Vector.<String>):void
		{
			var index:int;
			var key:String, value:String;
			
			var length:uint = refers.length;
			for (var i:int = 0; i < length; i++)
			{
				index = refers[i];
				value = strings[index];
				
				// 不在映射表里面的包名、类名不加密
				if (!_include[value]) continue;
				
				if (!value) continue;
				if (_reverse[value]) continue; // 已加密跳过
				
				while(true)
				{
					key = createEncryptSTR(value);
					if (!_reverse[key]) break;
				}
				
				_map[value] = key;
				_reverse[key] = value;
				
				_names.push(value);
			}
		}
		
		// 导入配置
		private function importConfig(settings:XML):void
		{
			if (!settings) return;
			
			var key:String, value:String;
			var config:XMLList = settings.children();
			
			// 导入配置前清空配置
			_map = new Dictionary(true);
			_reverse = new Dictionary(true);
			
			// 导入全新配置
			for each (var item:XML in config)
			{
				key = String(item.@key);
				value = String(item.@value);
				if (!key || !value) continue;
				
				_map[key] = value;
				_reverse[value] = key;
			}
		}
		
		// 导出配置
		private function exportConfig():XML
		{
			var item:XML;
			var settings:XML = new XML("<encrypt/>");
			for (var key:String in _map)
			{
				item = new XML("<item/>");
				
				item.@key = key;
				item.@value = _map[key];
				
				settings.appendChild(item);
			}
			
			return settings;
		}
		
		// 替换加密串
		private function replace(strings:Vector.<String>, offset:uint = 0):void
		{
			var value:String, key:String;
			var length:int = strings.length;
			for(var i:int = offset; i < length; i++)
			{
				value = strings[i];
				for (var k:int = 0; k < _names.length; k++)
				{
					key = _names[k];
					if (value.indexOf(key) >= 0)
					{
						while (value.indexOf(key) >= 0)
						{
							value = value.replace(key, _map[key]);
						}
						
						strings[i] = value;
					}
				}
			}
		}
		
		// 获取加密字符串
		private function createEncryptSTR(source:String):String
		{
			var result:String = "";
			
			var min:uint, max:uint;
			min = 33; max = 126;
			
			var length:uint = 3 + Math.round(7 * Math.random());
			
			var char:String;
			while (result.length < length)
			{
				char = String.fromCharCode(min + (max - min) * Math.random() >> 0);
				result += char;
			}
			
			assertTrue(result.length == length);
			
			return result;
		}
		
		/**
		 * 加密文件
		 * @param swf	SWFile对象
		 */		
		public function addFile(swf:SWFile):void
		{
			_files.push(swf);
			
			var list:Vector.<DoABCTag> = new Vector.<DoABCTag>();
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC) 
				{
					list.push(tag as DoABCTag);
				}
			}
			
			processABCTags(list);
			
			// 制作导入类映射表
			var definition:String;
			for each(var item:EncryptItem in _queue)
			{
				var multinames:Vector.<MultinameInfo> = item.tag.abc.constants.multinames;
				for each (var info:MultinameInfo in multinames)
				{
					if (info && info.definition)
					{
						definition = info.toString();
						if (_include[definition]) continue;
						
						_exclude[definition] = definition;
					}
				}
			}
			
			_exclude = def2map(_exclude);
			
			// 制作项目类映射表，并剔除导入类
			_include = def2map(_include, _exclude);
		}
		
		// definition split map
		private function def2map(dict:Dictionary, exclude:Dictionary = null):Dictionary
		{
			exclude ||= new Dictionary(true);
			
			var list:Array = [];
			for each (var key:String in dict)
			{
				list.push.apply(null, key.split(":"));
			}
			
			var result:Dictionary = new Dictionary(true);
			for each (key in list)
			{
				if (!exclude[key]) 
				{
					result[key] = true;
				}
			}
			
			return result;
		}
		
		/**
		 * 批量处理ABC 
		 * @param list	DoABCTag对象数组
		 */		
		private function processABCTags(list:Vector.<DoABCTag>):void
		{
			var tag:DoABCTag;
			var item:EncryptItem;
			var definition:String;
			
			for each(tag in list)
			{
				_queue.push(item = new EncryptItem(tag));
				
				for each(var script:ScriptInfo in tag.abc.scripts)
				{
					for each(var trait:TraitInfo in script.classes)
					{
						var cls:ClassInfo = tag.abc.classes[trait.data.classi];
						var multiname:MultinameInfo = tag.abc.constants.multinames[cls.instance.name];
						switch (multiname.kind)
						{
							case MultiKindType.QNAME:
							case MultiKindType.QNAME_A:
							{
								definition = multiname.toString();
								if (!_include[definition])
								{
									_include[definition] = definition;
									item.packages.push(tag.abc.constants.namespaces[multiname.ns].name);
									item.classes.push(multiname.name);
								}
								
								break;
							}
						}
					}
				}
			}
		}
	}
}