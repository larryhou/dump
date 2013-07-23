package scripts
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.ScriptLimitsTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	
	/**
	 * 测试脚本限制
	 * @author larryhou
	 * @createTime Apr 7, 2013 9:52:06 PM
	 */
	public class ScriptMain extends Sprite
	{
		[Embed(source="timeoutModule.swf", mimeType="application/octet-stream")]
		private var FileByteArray01:Class;
		
		[Embed(source="recursionModule.swf", mimeType="application/octet-stream")]
		private var FileByteArray02:Class;
		
		private static const TIME_OUT_MODE:Boolean = false;
		
		/**
		 * 构造函数
		 * create a [ScriptMain] object
		 */
		public function ScriptMain()
		{
			var swf:SWFile;
			
			if (TIME_OUT_MODE)
			{
				swf = new SWFile(new FileByteArray01());
			}
			else
			{
				swf = new SWFile(new FileByteArray02());
			}
			
			for each(var tag:SWFTag in swf.tags)
			{
				if (tag.type == TagType.SCRIPT_LIMITS) break;
			}
			
			var limit:ScriptLimitsTag = tag as ScriptLimitsTag;
			if (!limit) 
			{
				limit = new ScriptLimitsTag();
				
				// 放到第三个索引
				swf.tags.splice(2, 0, limit);
			}
			
			if (TIME_OUT_MODE)
			{
				limit.timeout = 1;
			}
			else
			{
				limit.recursion = 5;
				new FileReference().save(swf.repack(), "recursion.swf");
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			TIME_OUT_MODE && loader.loadBytes(swf.repack(), new LoaderContext(false, new ApplicationDomain()));
			
			addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		protected function frameHandler(event:Event):void
		{
			//trace(getTimer());
		}
		
		/**
		 * 加载完成
		 */		
		protected function completeHandler(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			addChild(loaderInfo.content);
		}		
		
	}
}