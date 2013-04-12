package closure
{
	/**
	 * 构造函数
	 * create a [closureFunction] object
	 */
	public function globalFunction(key:String = null):void
	{
		var result:String = "globalFunction: " + this;
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