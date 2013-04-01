package debug
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.display.Sprite;
	
	/**
	 * debug和release
	 * @author larryhou
	 * @createTime Apr 1, 2013 11:11:18 AM
	 */
	public class DebugMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [DebugMain] object
		 */
		public function DebugMain()
		{
			var swf:SWFile = new SWFile(loaderInfo.bytes);
			
			var tag:DoABCTag;
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				if (swf.tags[i].type == DoABCTag.TYPE)
				{
					tag = swf.tags[i] as DoABCTag;
					trace("\n\n-----------------------------------------\n");
					//trace(tag.abc.constants.strings.join("\n"));
					trace(tag.abc.files.join("\n"));
					//break;
				}
			}
		}
	}
}