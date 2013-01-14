package
{
	
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 3:05:12 AM
	 */
	public class TestMain extends Sprite
	{
		private var _canvas:Graphics;
		
		/**
		 * 构造函数
		 * create a [TestMain] object
		 */
		public function TestMain()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}		
		
		private function init(e:Event):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.loadBytes(loaderInfo.bytes, new LoaderContext(false, new ApplicationDomain()));
			
			trace("Task@2");
		}
		protected function completeHandler(e:Event):void
		{
			// TODO Auto-generated method stub
			trace("Task@1");
		}
		
	}
}