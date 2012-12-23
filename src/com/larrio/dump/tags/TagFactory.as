package com.larrio.dump.tags
{
	
	/**
	 * TAG工厂类
	 * @author larryhou
	 * @createTime Dec 16, 2012 12:24:04 PM
	 */
	public class TagFactory
	{
		
		/**
		 * 构造函数
		 * create a [TagFactory] object
		 */
		public function TagFactory()
		{
			
		}
		
		/**
		 * 工厂类生成SWFTag对象
		 * @param type	TAG类型
		 * @return SWFTag object
		 */		
		public static function create(type:int):SWFTag
		{
			switch(type)
			{
				case TagType.DO_ABC:
				{
					return new DoABCTag();
				}
				
				case TagType.SYMBOL_CLASS:
				{
					return new SymbolClassTag();
				}
					
				case TagType.FILE_ATTRIBUTES:
				{
					return new FileAttributesTag();
				}
					
				case TagType.FRAME_LABEL:
				{
					return new FrameLabelTag();
				}
					
				case TagType.END:
				{
					return new EndTag();
				}
			}
			
			return new SWFTag();
		}		
	}
}