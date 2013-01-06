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
		
		private var _undup:Dictionary;
		private var _symbols:Dictionary;
		private var _interfaces:Dictionary;
		
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
			
			_undup = new Dictionary(true);
			_symbols = new Dictionary(true);
			_interfaces = new Dictionary(true);
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
					
					if (item.protocol)
					{
						key = value;
						
						_interfaces[value] = value;
					}
					else
					{
						while(true)
						{
							key = createEncryptSTR(value);
							if (!_reverse[key]) break;
						}
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
				if (value.indexOf(":") > 0 || value.indexOf("$") > 0)
				{
					for (var j:int = 0; j < _names.length; j++)
					{
						key = _names[j];
						if (value.indexOf(key) >= 0)
						{
							value = value.replace(key, _map[key]);
							strings[i] = value;
							break;
						}
					}
				}
				else
				{
					if (_map[value] is String) strings[i] = _map[value];
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
			
			var length:uint = 3 + Math.round(5 * Math.random());
			
			var char:String;
			while (result.length < length)
			{
				char = String.fromCharCode(min + (max - min) * Math.random() >> 0);
				if (char == "." || char == ":") continue;
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
			
			for each(var def:String in swf.symbol.symbols)
			{
				def = def.replace(/(\.)(\w+)$/, ":$2");
				_symbols[def] = def;
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
			var exclude:Dictionary = new Dictionary(true);
			
			var definition:String;
			for each (var swf:SWFile in _files)
			{
				// 链接名不做加密处理
				for each (definition in swf.symbol.symbols) exclude[definition] = definition.replace(/(\.)(\w+)$/, ":$2");
			}
			
			// 制作导入类映射表
			for each(var item:EncryptItem in _queue)
			{
				var multinames:Vector.<MultinameInfo> = item.tag.abc.constants.multinames;
				for each (var info:MultinameInfo in multinames)
				{
					if (info && info.definition)
					{
						definition = info.toString();
						if (_include[definition]) continue;
						
						exclude[definition] = definition;
					}
				}
			}
			
			exclude = def2map(exclude);
			
			_names = new Vector.<String>();
			for (var key:String in _map)
			{
				if (key) _names.push(key);
			}
			
			// 按照长度降序排列
			_names.sort(function (s1:String, s2:String):int
			{
				return s1.length > s2.length? -1 : 1;
			});
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
								if (_symbols[key]) break;	// 链接名不加密
								
								definition = new DefinitionItem();
								definition.name = item.strings[multiname.name];
								
								// 删除同名类
								if (_undup[definition.name])
								{
									// 保证同名类不加密
									delete _include[_undup[definition.name]];
									break;
								}
								
								if (!_include[key])
								{
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