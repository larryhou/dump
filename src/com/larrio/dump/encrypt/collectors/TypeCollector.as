package com.larrio.dump.encrypt.collectors
{
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.dump.doabc.InstanceInfo;
	import com.larrio.dump.doabc.MethodInfo;
	import com.larrio.dump.doabc.MultinameInfo;
	import com.larrio.dump.doabc.OptionInfo;
	import com.larrio.dump.doabc.ScriptInfo;
	import com.larrio.dump.doabc.TraitInfo;
	import com.larrio.dump.interfaces.IScript;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 23, 2013 11:43:59 PM
	 */
	public class TypeCollector extends SWFCollector
	{
		public var types:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [TypeCollector] object
		 */
		public function TypeCollector()
		{
			types = new Vector.<String>;
		}
				
		override protected function collectFromABC(abc:DoABC):void
		{
			var item:String, trait:TraitInfo;
			for each(var script:ScriptInfo in abc.scripts)
			{
				collectFromScript(script, abc);
			}
		}
				
		private function collectFromScript(script:IScript, abc:DoABC):void
		{
			var item:String, trait:TraitInfo;
			for each(trait in script.slots)
			{
				if (trait.data.type)
				{
					item = abc.constants.multinames[trait.data.type].toString();
					if (!has(item))
					{
						add(item)
						types.push(item);
					}
				}
			}
			
			var method:MethodInfo;
			var multiname:MultinameInfo;
			for each(trait in script.methods)
			{
				method = abc.methods[trait.data.method];				
				
				for each(var pt:uint in method.paramTypes)
				{
					multiname = abc.constants.multinames[pt];
					if (!multiname) continue;
					
					item = multiname.toString();
					if (!has(item))
					{
						add(item);
						types.push(item);
					}
				}
				
				continue;
				item = abc.constants.multinames[method.returnType].toString();
				if (!has(item))
				{
					add(item);
					types.push(item);
				}
			}
			
			var instance:InstanceInfo;
			for each(trait in script.classes)
			{
				instance = abc.classes[trait.data.classi].instance;
				if (instance.superName)
				{
					item = abc.constants.multinames[instance.superName].toString();
					if (!has(item))
					{
						add(item);
						types.push(item);
					}
				}
			}
			
			for each(script in script.children) collectFromScript(script, abc);
		}
	}
}