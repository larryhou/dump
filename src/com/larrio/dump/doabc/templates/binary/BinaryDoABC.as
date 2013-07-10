package com.larrio.dump.doabc.templates.binary
{
	import com.larrio.dump.doabc.templates.DoABCFile;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 9:39:46 AM
	 */
	public class BinaryDoABC extends DoABCFile
	{
		[Embed(source="binary.abc", mimeType="application/octet-stream")]
		private var TemplateTag:Class;
		
		/**
		 * 构造函数
		 * create a [BinaryDoABC] object
		 */
		public function BinaryDoABC(name:String)
		{
			decodeDoABCTag(new TemplateTag());
			rename(name, null);
		}
		
		/**
		 * 修改类名
		 */		
		override protected function rename(value:String, indice:Array):void
		{
			value = value.replace(/^\s*|\s*$/g, "");
			if (!_tag || !value) return;
			
			var prefix:String = "";
			var list:Array = value.split("::");
			if (list.length == 2)
			{
				prefix = list.shift();
			}
			
			var className:String = list.pop();
			var qualifiedClassName:String = prefix + ":" + className;
			
			_tag.name = prefix.replace(/\./g, "/") + "/" + className;
			
			var strings:Vector.<String> = _tag.abc.constants.strings;
			strings[1] = qualifiedClassName;
			strings[3] = "";
			strings[4] = qualifiedClassName + "/" + className;
			strings[5] = prefix;
			strings[6] = className;
		}

	}
}