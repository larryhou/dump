package
{
	import flash.display.Sprite;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 3:05:12 AM
	 */
	public class TestMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [TestMain] object
		 */
		public function TestMain()
		{
			var doc:XMLDocument = new XMLDocument();
			var node:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "data");
			doc.appendChild(node);
			
			
			var config:XML = new XML("<encrypt/>");
			var item:XML;
			for (var i:int = 0; i < 10; i++)
			{
				item = new XML("<item/>");
				item.@id = i + 1;
				config.appendChild(item);
			}
			
			trace(config.toXMLString());
		}
		
		
	}
}