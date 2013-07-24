package com.larrio.dump.encrypt.core
{
	import com.larrio.dump.encrypt.collectors.ClassCollector;
	import com.larrio.dump.encrypt.collectors.TypeCollector;
	
	import flash.utils.Dictionary;
	
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 23, 2013 11:45:41 PM
	 */
	public class KeyChain
	{
		private var _map:Dictionary;
		private var _exclude:Dictionary;
		
		private var _strong:Boolean;
		
		private var _pool:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [KeyChain] object
		 */
		public function KeyChain()
		{
			_map = new Dictionary(false);
			_exclude = new Dictionary(false);
			
			this.strong = false;
		}
		
		/**
		 * 获取加密串
		 */		
		public function getKey(name:String):String
		{
			if (_map[name] is Function) return null;
			if (_map[name] is Class) return null;
			return _map[name];
		}
		
		/**
		 * 创建加密串映射表 
		 */		
		public function createKeys(typeCollector:TypeCollector, classCollector:ClassCollector):void
		{
			var includes:Vector.<String> = adjust(classCollector.classes.concat());
			var interfaces:Vector.<String> = adjust(classCollector.interfaces.concat());
			
			var excludes:Vector.<String> = adjust(adjust(classCollector.interfaces.concat()));
			excludes = excludes.concat(adjust(classCollector.symbols));
			
			var className:String;
			var dict:Dictionary = new Dictionary(true);
			for each(className in includes) dict[className] = true;
			
			var types:Vector.<String> = adjust(typeCollector.types.concat());
			
			for (var i:int = 0; i < types.length; i++)
			{
				className = types[i];
				if (!dict[className] && excludes.indexOf(className) < 0) excludes.push(className);
			}
						
			var value:String;
			var prefix:String,name:String;
			
			var list:Array, item:String;
			for each(className in excludes)
			{
				list = formatItem(className);
				prefix = list[0]; name = list[1];
				
				while (list.length)
				{
					item = list.shift();
					if (item) _exclude[item] = true;
				}
				
				if (prefix)
				{
					_exclude[prefix + ":" + name] = true;
				}
			}
			
			var reg:RegExp = /\.as\$\d+$/i;
			
			var key:String;
			for each(className in includes)
			{
				list = formatItem(className);
				prefix = list[0]; name = list[1];
				
				while (list.length)
				{
					item = list.shift();
					if (item)
					{
						if (_map[item]) continue;
						if (_exclude[item]) 
						{
							_map[item] = item;
							continue;
						}
						
						if (item.match(reg)) continue;
						
						key = null;
						while(!key || _map[key])
						{
							key = randomKey(item, _pool);
						}
						
						_map[item] = key;
					}
				}
				
				if (!prefix) continue;
				
				value = prefix + ":" + name;
				if (_exclude[value]) continue;
				
				if (prefix.match(reg))
				{
					var suffix:String = prefix.match(reg)[0];
					
					prefix = prefix.replace(suffix, "");
					key = _map[prefix] + suffix + ":" + _map[name];
				}
				else
				{
					key = _map[prefix] + ":" + _map[name];
				}
				
				if (!_map[value])
				{
					_map[value] = key;
				}
				
				value += "/" + name;
				if (_exclude[value]) continue;
				
				key += "/" + _map[name];
				if (!_map[value])
				{
					_map[value] = key;
				}
			}
		}
		
		private function formatItem(name:String):Array
		{
			var list:Array = name.split(":");
			if (list.length == 1) list.unshift(null);
			if (list.length != 2)
			{
				throw new ArgumentError("Invalidate class name:" + name);
			}
			
			return list;
		}
		
		private function adjust(list:Vector.<String>):Vector.<String>
		{
			var name:String;
			for (var i:int = 0, length:uint = list.length; i < length; i++)
			{
				name = list[i];
				if (name.indexOf("__AS3__.vec:Vector.") == 0)
				{
					name = name.match(/<([^>]+)>/)[1];
				}
				
				name.replace(/:\w+:/g, ":");
				name = name.replace(/\.(\w+)$/, ":$1");
				list[i] = name;
			}
			
			return list;
		}
		
		/**
		 * 随机出一个加密串
		 */		
		private function randomKey(source:String, pool:Vector.<String>):String
		{
			var result:String = "";
			var length:uint = 2 + 7 * Math.random() >> 0;
			
			var char:String;
			while (result.length < length)
			{
				char = pool[pool.length * Math.random() >> 0];
				if (char == "." || char == ":") continue;
				result += char;
			}
			
			return result;
		}
		
		/**
		 * 导入加密配置表
		 */		
		private function importKeys(settings:XML):void
		{
			if (!settings) return;
			
			var name:String, key:String;
			
			var data:XML = settings.includes[0];
			var list:XMLList = data.children();
			
			for each (var item:XML in list)
			{
				name = String(item.@name);
				key = String(item.@key);
				
				if (name && key && _map[name])
				{
					_map[name] = key;
				}
			}
			
			data = settings.excludes[0];
			list = data.children();
			
			for each(item in list)
			{
				name = String(item.@name);
				if (name && !_exclude[name])
				{
					_exclude[name] = true;
				}
			}
		}
		
		/**
		 * 导出加密配置表
		 */		
		private function exportKeys():XML
		{
			var settings:XML = new XML("<keys/>");
			settings.@timestamp = new Date().time / 1000 >> 0;
			
			var data:XML = new XML("<includes/>");
			
			var item:XML, name:String;
			for (name in _map)
			{
				item = new XML("<item/>");
				item.@name = name;
				item.@key = _map[name];
				data.appendChild(item);
			}
			
			settings.appendChild(data);
			
			data = new XML("<excludes/>");
			for (name in _exclude)
			{
				item = new XML("<item/>");
				item.@name = name;
				data.appendChild(item);
			}
			
			settings.appendChild(data);
			
			return settings;
		}

		/**
		 * 加密配置表
		 */		
		public function get settings():XML { return exportKeys(); }
		public function set settings(value:XML):void
		{
			importKeys(value);
		}

		/**
		 * 是否启用高强度加密模式
		 */		
		public function get strong():Boolean { return _strong; }
		public function set strong(value:Boolean):void
		{
			_strong = value;
			
			var list:Array = new Array();
			if (_strong)
			{
				list.push([33, 45]);
				list.push([59, 64]);
				list.push([91, 96]);
				list.push([123, 126]);
				list.push([161, 255]);
			}
			else
			{
				list.push([65, 90]);
				list.push([97, 122]);
			}
			
			_pool = new Vector.<String>;
			
			var range:Array;
			while (list.length)
			{
				range = list.shift();
				for (var code:int = range[0]; code <= range[1]; code++)
				{
					_pool.push(String.fromCharCode(code));
				}
			}			
		}

	}
}