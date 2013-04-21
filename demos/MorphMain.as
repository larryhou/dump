package
{
	import com.larrio.dump.SWFile;
	
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Apr 22, 2013 1:23:20 AM
	 */
	public class MorphMain extends Sprite
	{
		[Embed(source="../libs/morph.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;

		/**
		 * 构造函数
		 * create a [MorphMain] object
		 */
		public function MorphMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray());
			trace(swf);
		}
	}
}