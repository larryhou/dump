package com.larrio.dump.doabc
{
	
	
	/**
	 * 类文件信息
	 * @author larryhou
	 * @createTime Dec 20, 2012 12:09:17 PM
	 */
	public class ClassFile
	{
		private var _name:String;
		private var _content:String;
		
		/**
		 * 构造函数
		 * create a [ClassFile] object
		 */
		public function ClassFile(script:ScriptInfo, abc:DoABC)
		{
			process(script, abc);
		}
		
		// 处理脚本
		private function process(script:ScriptInfo, abc:DoABC):void
		{
			_content = "";
			
			var trait:TraitInfo;
			var length:int, i:int;
			
			if (script.classes)
			{	
				length = script.classes.length;
				for (i = 0; i < length; i++)
				{
					trait = script.classes[i];
					processClassInfo(abc.classes[trait.data.classi], abc);
				}
			}
			
			var appending:String = "";
			
			// instance class info
			if (script.variables) appending += "\n\t" + variableSTR(script.variables, abc);
			if (script.methods)
			{				
				length = script.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = script.methods[i];
					
					appending += "\n";
					appending += "\n" + methodSTR(trait.data.method, abc, trait);
				}
			}
			
			if (appending)
			{
				_content += "\nPACKAGE MEMBERS:" + appending;
			}
			
		}
		
		// 处理类文件
		private function processClassInfo(info:ClassInfo, abc:DoABC):void
		{
			var trait:TraitInfo;
			var length:int, i:int;
			var multinames:Vector.<MultinameInfo> = abc.constants.multinames;
			
			var option:String = "";
			var instance:InstanceInfo = info.instance;
			if ((instance.flags & InstanceType.CLASS_FINAL) == InstanceType.CLASS_FINAL)
			{
				option += "final ";
			}
			
			if ((instance.flags & InstanceType.CLASS_SEALED) != InstanceType.CLASS_SEALED)
			{
				option += "dynamic ";
			}
			
			if ((instance.flags & InstanceType.CLASS_PROTECTED_NS) == InstanceType.CLASS_PROTECTED_NS)
			{
				//option += "protected ";
			}
			
			_name = multinames[instance.name].toString();
			
			_content += option + (instance.protocol? "interface " : "class ") + _name;
			if (multinames[instance.superName]) _content += " extends " + multinames[instance.superName];
			
			var list:Array = [];
			for (i = 0; i < instance.interfaces.length; i++)
			{
				list.push(multinames[instance.interfaces[i]]);
			}
			
			if (list.length) _content += " implements " + list.join(",");
			
			if(info.traits.length) 
			{
				_content += "\n";
				_content += "\nSTATIC MEMBERS:";
			}
			
			// static class info
			if (info.variables) _content += "\n\t" + variableSTR(info.variables, abc);
			if (info.methods)
			{				
				length = info.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = info.methods[i];
					
					_content += "\n";
					_content += "\n" + methodSTR(trait.data.method, abc, trait);
				}
			}
			
			if (instance.traits.length)
			{
				_content += "\n";
				_content += "\nINSTANCE MEMBERS:";
			}

			// instance class info
			if (instance.variables) _content += "\n\t" + variableSTR(instance.variables, abc);
			if (!instance.protocol)
			{
				_content += "\n";
				_content += "\n" + methodSTR(instance.initializer, abc);
			}
			
			if (instance.methods)
			{
				length = instance.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = instance.methods[i];
					
					_content += "\n";
					_content += "\n" + methodSTR(trait.data.method, abc, trait);
				}
			}
			
			_content += "\n";
		}
		
		// 变量转换成字符串
		private function variableSTR(variables:Vector.<TraitInfo>, abc:DoABC):String
		{
			var trait:TraitInfo;
			var length:uint, i:int;
			
			var item:String;
			var name:String;
			var result:Array = [];
			
			length = variables.length;
			for (i = 0; i < length; i++)
			{
				trait = variables[i];
				
				item = metadataSTR(trait.metadatas, abc);
				if (item) item += "\n\t";
				
				name = trait.toString().replace(/(private|protected|internal)\s*(\w+:\w+)/, "$1 var $2");
				if (name.indexOf("const") == 0)
				{
					name = "public " + name;
				}
				else
				{
					if (!name.match(/(private|protected|internal)/)) name = "public var " + name;
				}
				
				item += name;
				result.push(item);
			}
			
			return result.join("\n\t");
		}
		
		// 把函数转换成字符串
		private function methodSTR(method:uint, abc:DoABC, trait:TraitInfo = null):String
		{
			var metadata:String;
			var result:String = "", kind:uint = 0;
			var info:MethodInfo = abc.methods[method];
			
			if (trait)
			{
				kind = trait.kind >>> 4;
				metadata = metadataSTR(trait.metadatas, abc);
				if (metadata) result += metadata + "\n";
			}
			
			var attribute:String;
			if ((kind & TraitAttriType.FINAL) == TraitAttriType.FINAL)
			{
				attribute = "final";
			}
			
			if ((kind & TraitAttriType.OVERRIDE) == TraitAttriType.OVERRIDE)
			{
				attribute = "override";
			}
			
			if (attribute) result += attribute + " ";
			
			if (!abc.constants.strings[info.name]) 
			{
				result += _name + "/";
				if (trait)
				{
					result += abc.constants.multinames[trait.name];
				}
				else
				{
					result += _name.match(/\w+$/);
				}
			}
			
			result += info;
			if (info.body) result += "\n" + info.body;
			return result;
		}
		
		// 元数据字符串输出
		private function metadataSTR(metadatas:Vector.<uint>, abc:DoABC):String
		{
			if (!metadatas || !metadatas.length) return "";
			
			var item:String;
			
			var result:Array = []
			var length:uint = metadatas.length;
			for (var i:int = 0; i < length; i++)
			{
				item = abc.metadatas[metadatas[i]].toString();
				if (item.indexOf("__go_to_") < 0) result.push(item);
			}
			
			return result.join("\n\t");
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return _content;
		}
		
		/**
		 * 类文件信息
		 */		
		public function get content():String { return _content; }

		/**
		 * 类完全限定名
		 */		
		public function get name():String { return _name; }

	}
}