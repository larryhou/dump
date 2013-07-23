package com.larrio.dump.encrypt.collectors
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.SymbolClassTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 23, 2013 11:58:49 PM
	 */
	public class SWFCollector
	{
		private var _map:Dictionary;
		private var _index:uint;
		
		/**
		 * 构造函数
		 * create a [SWFCollector] object
		 */
		public function SWFCollector()
		{
			_map = new Dictionary(false);
		}
		
		/**
		 * 添加SWF文件 
		 * @param swf	SWFile对象
		 */		
		public function collect(swf:SWFile):void
		{
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DO_ABC)
				{
					collectFromABC((tag as DoABCTag).abc);
				}
				else
				if (tag.type == TagType.SYMBOL_CLASS)
				{
					collectFromSymbol(tag as SymbolClassTag);
				}
			}
		}
		
		protected function collectFromSymbol(symbolTag:SymbolClassTag):void
		{
			
		}
		
		protected function collectFromABC(abc:DoABC):void
		{
			
		}
		
		protected final function add(key:String):String
		{
			if (!_map[key]) _map[key] = ++_index;
			return key;
		}
		
		protected final function has(key:String):Boolean
		{
			return _map[key] != null;
		}
		
		protected final function remove(key:String):String
		{
			if (_map[key]) delete _map[key];
			return key;
		}

	}
}