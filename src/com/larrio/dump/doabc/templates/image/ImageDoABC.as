package com.larrio.dump.doabc.templates.image
{
	import com.larrio.dump.doabc.templates.DoABCFile;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 9:40:18 AM
	 */
	public class ImageDoABC extends DoABCFile
	{
		[Embed(source="image.abc", mimeType="application/octet-stream")]
		private var TemplateTag:Class;
		
		/**
		 * 构造函数
		 * create a [JPEGDoABC] object
		 */
		public function ImageDoABC(name:String)
		{
			decodeDoABCTag(new TemplateTag());
			rename(name, [3, 4, 7]);
		}
	}
}