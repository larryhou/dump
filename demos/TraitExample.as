package
{
	import flash.utils.getTimer;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Apr 10, 2013 8:05:35 PM
	 */
	public class TraitExample
	{
		public static const VERSION:String = "v1.0";
		public static var sequence:uint = 0;	
		
		public static function create():Object
		{
			return {};
		}
		
		private const MAX_NUM:uint = 0xFF;
		private var _id:uint;
		
		public var name:String;
		
		public function TraitExample()
		{
			var callback:Function = function ():void
			{
				trace(getTimer());
			};
		}
		
		public function count():uint
		{
			return 10;
		}

		public function get id():uint { return _id; }
		public function set id(value:uint):void
		{
			_id = value;
		}

	}
}