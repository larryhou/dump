package doabc
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.encrypt.FileEncryptor;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 24, 2013 12:21:31 AM
	 */
	public class SimpleEncryptMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [SimpleEncryptMain] object
		 */
		public function SimpleEncryptMain()
		{
			var label:TextField = new TextField();
			label.defaultTextFormat = new TextFormat("Monaco", 50, 0xFF0000, true);
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			label.text = "Hello World!";
			
			var swf:SWFile = new SWFile(loaderInfo.bytes);
			
			var settings:XML;
			var encryptor:FileEncryptor = new FileEncryptor();
			encryptor.pushSWF(swf);
			settings = encryptor.encrypt();
			trace(settings.toXMLString());
			trace(encryptor.log);
			
			var bytes:ByteArray = swf.repack();
			new FileReference().save(bytes, "encrypt.swf");
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			//loader.loadBytes(bytes);
		}
		
		protected function completeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
	}
}