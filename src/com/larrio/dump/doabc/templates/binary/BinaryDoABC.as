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
			rename(name);
		}
	}
}