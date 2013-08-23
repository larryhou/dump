package demos.debug
{
	import com.larrio.dump.SWFile;
	
	import flash.display.Sprite;
	
	
	/**
	 * 测试类
	 * @author larryhou
	 * @createTime Apr 1, 2013 11:35:45 AM
	 */
	public class CodeModule extends Sprite
	{
		[Embed(source="../../libs/res01.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [FileMain] object
		 */
		public function CodeModule()
		{
			var swf:SWFile = new SWFile(loaderInfo.bytes);
		}
	}
}