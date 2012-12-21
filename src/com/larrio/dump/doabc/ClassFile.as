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
			if (script.variables) appending += "\n\t" + script.variables.join("\n\t");
			if (script.methods)
			{				
				length = script.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = script.methods[i];
					
					appending += "\n";
					appending += "\n" + methodSTR(trait.data.method, abc);
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
			
			var instance:InstanceInfo = info.instance;
			var multinames:Vector.<MultinameInfo> = abc.constants.multinames;
			
			_name = multinames[instance.name].toString();
			
			_content += "class " + _name;
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
			if (info.variables) _content += "\n\t" + info.variables.join("\n\t");
			if (info.methods)
			{				
				length = info.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = info.methods[i];
					
					_content += "\n";
					_content += "\n" + methodSTR(trait.data.method, abc);
				}
			}
			
			if (instance.traits.length)
			{
				_content += "\n";
				_content += "\nINSTANCE MEMBERS:";
			}

			// instance class info
			if (instance.variables) _content += "\n\t" + instance.variables.join("\n\t");
			if (instance.methods)
			{
				_content += "\n";
				_content += "\n" + methodSTR(instance.initializer, abc);
				
				length = instance.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = instance.methods[i];
					
					_content += "\n";
					_content += "\n" + methodSTR(trait.data.method, abc);
				}
			}
			
			_content += "\n";
		}
		
		// 把函数转换成代码
		private function methodSTR(method:uint, abc:DoABC):String
		{
			var info:MethodInfo = abc.methods[method];
			
			var result:String = info.toString();
			if (info.body) result += "\n" + info.body;
			return result;
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