package com.larrio.dump.tags
{
	import com.larrio.dump.model.ClipActions;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 26, 2012 9:50:56 AM
	 */
	public class PlaceObject2 extends PlaceObject
	{
		public static const TYPE:uint = TagType.PLACE_OBJECT2;
		
		private var _hasClipActions:uint;
		private var _hasClipDepth:uint;
		
		private var _hasName:uint;
		private var _hasRatio:uint;
		private var _hasColorTransform:uint;
		private var _hasMatrix:uint;
		private var _hasCharacter:uint;
		private var _move:uint;
		
		private var _ratio:uint;
		private var _name:String;
		private var _clipDepth:uint;
		
		private var _clipActions:Vector.<ClipActions>;
		
		
		/**
		 * 构造函数
		 * create a [PlaceObject2] object
		 */
		public function PlaceObject2()
		{
			
		}
	}
}