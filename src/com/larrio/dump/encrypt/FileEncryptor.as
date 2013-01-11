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
	 * 
	 * @usage 该类只能使用一次，如需反复加密则必须重新构造实例
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
		
		private var _undup:Dictionary;
		
		private var _decrypting:Boolean;
		
		/**
		 * 构造函数
		 * create a [FileEncryptor] object
		 */
		public function FileEncryptor()
		{
			_files = new Vector.<SWFile>;
			_queue = new Vector.<EncryptItem>;
			
			_map = new Dictionary(true);
			_reverse = new Dictionary(true);
			_include = new Dictionary(true);
			_exclude = new Dictionary(true);
			
			_undup = new Dictionary(true);
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
				setup(item.definitions);
			}
			
			optimize();
			
			var name:String;
			for each(item in _queue)
			{
				item.tag.modified = true;
				replace(item.strings, 1);
			}
			
			var def:String, key:String, list:Array;
			
			//  同步加密文档类对应symbol
			for each(var swf:SWFile in _files)
			{
				for each(var tag:SymbolClassTag in swf.symbolTags)
				{
					def = "";
					length = tag.symbols.length;
					for (i = 0; i < length; i++)
					{
						if (tag.ids[i] == 0)
						{
							tag.modified = true;
							def = tag.symbols[i];
							def = def.replace(/(\.)(\w+)$/, ":$2");
							
							list = def.split(":");
							for (var j:int = 0; j < list.length; j++)
							{
								key = list[j];
								if (_map[key] is String) list[j] = _map[key];
							}
							
							tag.symbols[i] = list.join(".");
							break;
						}
						
					}
					
					if (def) break;
				}
			}
			
			return exportConfig();
		}
		
		// 初始化加密key
		private function setup(definitions:Vector.<DefinitionItem>):void
		{
			var list:Array;
			
			var prefix:String;
			var key:String, value:String;
			
			var item:DefinitionItem;
			var length:uint = definitions.length;
			for (var i:int = 0; i < length; i++)
			{
				item = definitions[i];
				list = [item.ns, item.name];
				
				for each (value in list)
				{
					if (!value) continue;
					if (_map[value] || _reverse[value])
					{
						continue; // 已加密跳过
					}

					while(true)
					{
						key = createEncryptSTR(value);
						if (!_reverse[key]) break;
					}
					
					_map[value] = key;
					_reverse[key] = value;
				}
				
				prefix = item.ns? (item.ns + ":") : "";
				prefix += item.name;
				
				// 类定义
				value = prefix;
				if (!_map[value])					
				{
					key = item.ns? (_map[item.ns] + ":") : "";
					key += _map[item.name];
					
					_map[value] = key;
					_reverse[key] = value;
				}
				
				// 构造函数
				value = prefix + "/" + item.name;
				if (!_map[value])
				{
					key = item.ns? (_map[item.ns] + ":") : "";
					key += _map[item.name] + "/" + _map[item.name];
					
					_map[value] = key;
					_reverse[key] = value;
				}
				
				// 类文件
				value = item.name + ".as";
				if (!_map[value])
				{
					key = _map[item.name] + ".as";
					
					_map[value] = key;
					_reverse[key] = value;
				}
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
				if (value.indexOf(":") > 0 || value.indexOf(".as$") > 0)
				{
					if (value.indexOf("http:") >= 0) continue;
					
					for (var j:int = 0; j < _names.length; j++)
					{
						key = _names[j];
						if (value.indexOf(key) == 0)
						{
							value = value.replace(key, _map[key]);
							strings[i] = value;
							break;
						}
					}
				}
				else
				{
					if (_map[value] is String)
					{
						strings[i] = _map[value];
					}
				}				
			}
		}
		
		// 获取加密字符串
		private function createEncryptSTR(source:String):String
		{
			var result:String = "";
			
			var min:uint, max:uint;
			if (!_decrypting)
			{
				min = 33; max = 126;
				min = 161; max = 255;
			}
			else
			{
				min = 97; max = 122;
			}
			
			var length:uint = 1 + Math.round(7 * Math.random());
			
			var char:String;
			while (result.length < length)
			{
				char = String.fromCharCode(min + (max - min) * Math.random() >> 0);
				if (char == "." || char == ":") continue;
				result += char;
			}
			
			return result;
		}
		
		/**
		 * 加密文件
		 * @param swf	SWFile对象
		 */		
		public function addFile(swf:SWFile):void
		{
			_files.push(swf);
			
			var def:String;
			for each (var symbolTag:SymbolClassTag in swf.symbolTags)
			{
				var length:uint = symbolTag.symbols.length;
				for(var i:int = 0; i < length; i++)
				{
					// 文档类
					if (symbolTag.ids[i] == 0) continue;
					
					def = symbolTag.symbols[i];
					def = def.replace(/(\.)(\w+)$/, ":$2");
					_exclude[def] = def;
				}
			}
			
			var list:Vector.<DoABCTag> = new Vector.<DoABCTag>();
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC) 
				{
					list.push(tag as DoABCTag);
				}
			}
			
			processABCTags(list);
			
		}
		
		// 加密防错优化处理
		private function optimize():void
		{
			var key:String;
			
			_include = def2map(_include);
						
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
			for (key in _map) if (_exclude[key]) delete _map[key];
			
			_names = new Vector.<String>();
			for (key in _map) if (key) _names.push(key);
			
			// 按照长度降序排列
			_names.sort(function (s1:String, s2:String):int
			{
				return s1.length > s2.length? -1 : 1;
			});
		}
		
		// definition split map
		private function def2map(dict:Dictionary):Dictionary
		{
			var list:Array;
			for each (var key:String in dict)
			{
				list = key.split(":");
				for each (var item:String in list)
				{
					if (item) dict[item] = item;
				}
			}
			
			return dict;
		}
		
		/**
		 * 批量处理ABC 
		 * @param list	DoABCTag对象数组
		 */		
		private function processABCTags(list:Vector.<DoABCTag>):void
		{
			var tag:DoABCTag;
			var item:EncryptItem;
			
			var key:String;
			var definition:DefinitionItem;
			
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
								key = multiname.toString();
								
								if (_exclude[key]) break;	// 链接名不加密
								
								definition = new DefinitionItem();
								definition.name = item.strings[multiname.name];
								
								if (!_include[key])
								{
									// 删除同名类
									if (_undup[definition.name])
									{
										// 保证同名类不加密
										delete _include[_undup[definition.name]];
										break;
									}
									
									if (cls.instance.protocol) 
									{
										_exclude[key] = key;
										break;
									}
									
									_undup[definition.name] = _include[key] = key;
									
									definition.protocol = cls.instance.protocol;
									definition.ns = item.strings[tag.abc.constants.namespaces[multiname.ns].name];
									item.definitions.push(definition);
								}
								
								break;
							}
						}
					}
				}
			}
		}

		/**
		 * 逆向加密，提高已混淆代码反编译的可读性
		 */		
		public function get decrypting():Boolean { return _decrypting; }
		public function set decrypting(value:Boolean):void
		{
			_decrypting = value;
		}
	}
}