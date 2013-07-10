package com.larrio.dump.tags
{
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 10, 2013 2:14:58 PM
	 */
	public class DefineTagType
	{
		private static const _types:Dictionary = init();
		private static function init():Dictionary
		{
			var map:Dictionary = new Dictionary();
			
			// binary
			map[TagType.DEFINE_BINARY_DATA] = true;
			
			// bitmap
			map[TagType.DEFINE_BITS] = true;
			map[TagType.DEFINE_BITS_JPEG2] = true;
			map[TagType.DEFINE_BITS_JPEG3] = true;
			map[TagType.DEFINE_BITS_JPEG4] = true;
			map[TagType.DEFINE_BITS_LOSSLESS] = true;
			map[TagType.DEFINE_BITS_LOSSLESS2] = true;
			
			// font
			map[TagType.DEFINE_FONT] = true;
			map[TagType.DEFINE_FONT2] = true;
			map[TagType.DEFINE_FONT3] = true;
			map[TagType.DEFINE_FONT4] = true;
			
			// text
			map[TagType.DEFINE_TEXT] = true;
			map[TagType.DEFINE_TEXT2] = true;
			map[TagType.DEFINE_EDIT_TEXT] = true;
			
			// button
			map[TagType.DEFINE_BUTTON] = true;
			map[TagType.DEFINE_BUTTON2] = true;
			
			// shape
			map[TagType.DEFINE_SHAPE] = true;
			map[TagType.DEFINE_SHAPE2] = true;
			map[TagType.DEFINE_SHAPE3] = true;
			map[TagType.DEFINE_SHAPE4] = true;
			
			// morph shape
			map[TagType.DEFINE_MORPH_SHAPE] = true;
			map[TagType.DEFINE_MORPH_SHAPE2] = true;
			
			// movie clip
			map[TagType.DEFINE_SPRITE] = true;
			
			// sound
			map[TagType.DEFINE_SOUND] = true;
			
			return map;
		}
		
		/**
		 * 判断是否未定义类TAG 
		 * @param type	Tag类型
		 */		
		public static function isDefineTag(type:uint):Boolean
		{
			return Boolean(_types[type]);
		}
	}
}