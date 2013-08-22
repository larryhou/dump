package demos.product
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 9, 2013 8:15:45 PM
	 */
	public class ProductMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [ProductMain] object
		 */
		public function ProductMain()
		{
			var swf:SWFile = new SWFile(loaderInfo.bytes);
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.DEBUG_ID || tag.type == TagType.PRODUCT_INFO)
				{
					trace(tag);
				}
			}
		}
	}
}