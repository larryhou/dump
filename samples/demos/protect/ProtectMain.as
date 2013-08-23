package demos.protect
{
	import com.adobe.crypto.MD5;
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.ProtectTag;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Apr 8, 2013 6:04:00 PM
	 */
	public class ProtectMain extends Sprite
	{
		[Embed(source="../libs/res04.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [ProtectMain] object
		 */
		public function ProtectMain()
		{
			var swf:SWFile = new SWFile(new FileByteArray());
			var tag:ProtectTag = new ProtectTag();
			tag.password = MD5.hash("larryhou");
			
			swf.tags.splice(2, 0, tag);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(swf.repack(), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		protected function completeHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			addChild(loaderInfo.content);
		}
	}
}