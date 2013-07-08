package com.larrio.dump.doabc.templates.audio
{
	import com.larrio.dump.doabc.templates.DoABCFile;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 9:39:22 AM
	 */
	public class MP3DoABC extends DoABCFile
	{
		[Embed(source="mp3.abc", mimeType="application/octet-stream")]
		private var TemplateTag:Class;
		
		/**
		 * 构造函数
		 * create a [MP3DoABC] object
		 */
		public function MP3DoABC(name:String)
		{
			decodeDoABCTag(new TemplateTag());
			rename(name);
		}
	}
}