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
		private var _queue:Vector.<EncryptItem>;
		
		private var _map:Dictionary;
		private var _reverse:Dictionary;
		
		/**
		 * 构造函数
		 * create a [FileEncryptor] object
		 */
		public function FileEncryptor()
		{
			_queue = new Vector.<EncryptItem>;
			
			_map = new Dictionary(true);
			_reverse = new Dictionary(true);
		}
		
		/**
		 * 文件添加完成后调用此方法进行加密处理 
		 */		
		public function encrypt():void
		{
			var item:EncryptItem;
			var length:uint, i:int;
			
			var key:String;
			var value:String, index:uint;
			
			for each(item in _queue)
			{
				length = item.classes.length;
				for (i = 0; i < length; i++)
				{
					index = item.classes[i];
					value = item.strings[index];
					
					if (_reverse[value]) continue;
					if (_map[value])
					{
						item.strings[index] = _map[value];
						continue;
					}
					
					while(true)
					{
						key = createEncryptSTR(value);
						if (!_reverse[key]) break;
					}
					
					_map[value] = key;
					_reverse[key] = value;
					
					item.strings[index] = key;
				}
			}
			
			var name:String;
			for each(item in _queue)
			{
				length = item.strings.length;
				for(i = 1; i < length; i++)
				{
					value = item.strings[i];
					for(name in _map)
					{
						if (value.indexOf(name) >= 0)
						{
							value = value.replace(new RegExp(name, "g"), _map[name]);
							item.strings[i] = value;
							break;
						}
					}
				}
				
				for (name in _map)
				{
					value = item.tag.name;
					if (value.indexOf(name) >= 0)
					{
						value = value.replace(new RegExp(name, "g"), _map[name]);
						item.tag.name = value;
						break;
					}
				}
			}
		}
		
		// 获取加密字符串
		private function createEncryptSTR(source:String):String
		{
			var result:String = "";
			while (result.length < source.length)
			{
				result += String.fromCharCode(97 + Math.random() * (122 - 97) >> 0);
				//result += String.fromCharCode(33 + Math.random() * (126 - 33) >> 0);
			}
			
			return result;
		}
		
		/**
		 * 加密文件
		 * @param swf	SWFile对象
		 */		
		public function addFile(swf:SWFile):void
		{
			var list:Vector.<DoABCTag> = new Vector.<DoABCTag>();
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC) list.push(tag as DoABCTag);
			}
			
			processABCTags(list);
		}
		
		/**
		 * 批量处理ABC 
		 * @param list	DoABCTag对象数组
		 */		
		private function processABCTags(list:Vector.<DoABCTag>):void
		{
			var tag:DoABCTag;
			var item:EncryptItem;
			
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
								item.packages.push(tag.abc.constants.namespaces[multiname.ns].name);
								item.classes.push(multiname.name);
								break;
							}
						}
					}
				}
			}
		}
	}
}