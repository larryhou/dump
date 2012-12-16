package com.larrio.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	/**
	 * 格式化类型
	 * @author larryhou
	 * @createTime Dec 16, 2012 5:17:33 PM
	 */
	public function printTypes(cls:Class, length:uint, upper:Boolean = false):void
	{
		var list:Array = [];
		
		var key:String, type:int,item:Object;
		var map:Dictionary = new Dictionary();
		var config:XMLList = describeType(cls).constant;
		for each(var node:XML in config)
		{
			key = String(node.@name);
			type = cls[key];
			
			assertTrue(map[type] == null);
			
			map[type] = key;
			list.push(item = {name:key});
			
			key = upper? split(key) : key;
			item.data = padding("public static const " + key, length) + ":uint = " + padding("0x" + type.toString(16).toUpperCase() + ";", 5) + " // " + type;
		}
		
		list.sortOn("name");
		while(list.length)
		{
			trace(list.shift().data);
		}
	}
}

function split(key:String):String
{
	var list:Array = [0];
	
	var str:String;
	var index:int = 0;
	while(index < key.length)
	{
		str = key.charAt(index);
		if (str.toLowerCase() != str)
		{
			if (index - list[list.length - 1] >= 1) list.push(index);
		}
		
		index++;
	}
	
	list.push(key.length);
	
	var result:Array = [];
	for (var i:int = 0; i < list.length - 1; i++)
	{
		str = key.substring(list[i], list[i + 1]);
		result.push(str.toUpperCase());
	}
	
	return result.join("_");
}

function padding(str:String, length:int):String
{
	while(str.length < length) str += " ";
	return str;
}
