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
		public function ClassFile(info:ClassInfo, abc:DoABC)
		{
			process(info, abc);
		}
		
		// 处理类文件
		private function process(info:ClassInfo, abc:DoABC):void
		{
			var trait:TraitInfo;
			var length:int, i:int;
			
			var instance:InstanceInfo = info.instance;
			var multinames:Vector.<MultinameInfo> = abc.constants.multinames;
			
			_content = _name = multinames[instance.name].toString();
			if (multinames[instance.superName]) _content += " extends " + multinames[instance.superName];
			
			var list:Array = [];
			for (i = 0; i < instance.interfaces.length; i++)
			{
				list.push(multinames[instance.interfaces[i]]);
			}
			
			if (list.length) _content += " implements " + list.join(",");
			
			if(info.traits.length) _content += "\nstatic:";
			
			// static class info
			if (info.variables) _content += "\n\t" + info.variables.join("\n\t");
			if (info.methods)
			{
				if (info.initializer < abc.methodBodies.length)
				{
					_content += "\n\ninitializer";
					_content += "\n" + abc.methodBodies[info.initializer].toString();
				}
				
				length = info.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = info.methods[i];
					_content += "\n" + trait.toString();
					_content += "\n" + abc.methods[trait.data.method].toString();
					_content += "\n" + abc.methodBodies[trait.data.method].toString();
				}
			}
			
			if (instance.traits.length) _content += "\ninstance:";

			// instance class info
			if (instance.variables) _content += "\n\t" + instance.variables.join("\n\t");
			if (instance.methods)
			{
				if (instance.initializer < abc.methodBodies.length)
				{
					_content += "\n\ninitializer";
					_content += "\n" + abc.methodBodies[instance.initializer].toString();
				}
				
				length = instance.methods.length;
				for (i = 0; i < length; i++)
				{
					trait = instance.methods[i];
					_content += "\n" + trait.toString();
					_content += "\n" + abc.methods[trait.data.method].toString();
					
					if (trait.data.method < abc.methodBodies.length)
					{
						_content += "\n" + abc.methodBodies[trait.data.method].toString();
					}
				}
			}
			
			trace(_content);
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