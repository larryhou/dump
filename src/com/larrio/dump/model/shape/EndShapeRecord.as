package com.larrio.dump.model.shape
{
	/**
	 * 
	 * @author larryhou
	 * @createTime Aug 17, 2015 9:12:51 PM
	 */
	public class EndShapeRecord extends ShapeRecord
	{
		/**
		 * 构造函数
		 * create a [EndEdgeRecord] object
		 */
		public function EndShapeRecord()
		{
			super(0);
		}
		
		override public function get type():uint { return ShapeRecordType.END_SHAPE_RECORD; }
	}
}