package closure
{
	import com.larrio.dump.doabc.ExceptionInfo;
	
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Apr 10, 2013 9:48:34 AM
	 */
	public class ClosureMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [ClosureMain] object
		 */
		public function ClosureMain()
		{
			
			execute({}, 1);
			execute.call(null, {}, 1);
			execute.apply(null, [{}, 1]);
			trace("----------------------");
			
			var callback:Function = function (key:String = null):void
			{
				var result:String = "callback: " + this;
				if (key)
				{
					try
					{
						result += key + ":" + this[key];
					} 
					catch(error:Error) 
					{
						trace(error);
					}
				}
				
				trace(result);
			};
			
			callback.call(null, "name");
			callback.call(this, "name");
			
			method.call();
			globalFunction();
		}
		
		private function execute(param1:Object, param2:Object, param3:Object = null):void
		{
			var list:Array = arguments;
			trace(list.length + "#param1: " + param1 + ", param2: " + param2 + ", param3: " + param3);
		}
		
		private function method(key:String = null):void
		{
			var result:String = "method: " + this;
			if (key)
			{
				try
				{
					result += key + ":" + this[key];
				} 
				catch(error:Error) 
				{
					trace(error);
				}
			}
			
			trace(result);
		}
	}
}