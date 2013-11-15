package com.larrio.dump.doabc.actions
{
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 10:46:57 PM
	 */
	public class ActionFactory
	{
		/**
		 * 构造函数
		 * create a [ActionFactory] object
		 */
		public function ActionFactory()
		{
			
		}
		
		/**
		 * 工厂方法获取DoAction解析器 
		 * @param type	action code
		 * @return ActionRecord object
		 */		
		public static function create(type:uint):ActionRecord
		{
			switch(type)
			{
				case ActionType.GOTO_FRAME:
				{
					
					break;
				}
					
			}
			
			return new ActionRecord();
		}
	}
}