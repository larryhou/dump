package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 11:18:35 PM
	 */
	public class ImportAssetsTag extends ExportAssetsTag
	{
		public static const TYPE:uint = TagType.IMPORT_ASSETS;
		
		/**
		 * 构造函数
		 * create a [ImportAssetsTag] object
		 */
		public function ImportAssetsTag()
		{
			
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<ImportAssetsTag/>");
			
			var item:XML;
			var length:uint = _ids.length;
			for (var i:int = 0; i < length; i++)
			{
				item = new XML("<asset/>");
				item.@id = _ids[i];
				item.@name = _names[i];
				result.appendChild(item);
			}
			
			return result.toXMLString();	
		}
		
	}
}