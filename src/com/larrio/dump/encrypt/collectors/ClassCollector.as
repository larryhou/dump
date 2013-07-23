package com.larrio.dump.encrypt.collectors
{
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.dump.doabc.InstanceInfo;
	import com.larrio.dump.doabc.ScriptInfo;
	import com.larrio.dump.doabc.TraitInfo;
	import com.larrio.dump.tags.SymbolClassTag;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 23, 2013 11:44:09 PM
	 */
	public class ClassCollector extends SWFCollector
	{
		public var interfaces:Vector.<String>;
		public var classes:Vector.<String>;
		public var symbols:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [DefinitionCollector] object
		 */
		public function ClassCollector()
		{
			interfaces = new Vector.<String>;
			classes = new Vector.<String>;
			symbols = new Vector.<String>;
		}
		
		override protected function collectFromABC(abc:DoABC):void
		{
			var item:String, instance:InstanceInfo
			for each(var script:ScriptInfo in abc.scripts)
			{
				for each(var trait:TraitInfo in script.classes)
				{
					instance = abc.classes[trait.data.classi].instance;
					item = abc.constants.multinames[instance.name].toString();
					if (!has(item))
					{
						add(item);
						instance.protocol? interfaces.push(item) : classes.push(item);
					}
				}
			}
		}
		
		override protected function collectFromSymbol(symbolTag:SymbolClassTag):void
		{
			var item:String;
			for (var i:uint = 0; i < symbolTag.symbols.length; i++)
			{
				item = symbolTag.symbols[i];
				if (symbolTag.ids[i] != 0)
				{
					symbols.push(item);
				}
			}
		}
	}
}