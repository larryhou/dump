package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.FilterList;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 26, 2012 11:29:09 PM
	 */
	public class PlaceObject3Tag extends PlaceObject2Tag
	{
		public static const TYPE:uint = TagType.PLACE_OBJECT3;
		
		private var _hasImage:uint;
		private var _hasClassName:uint;
		private var _hasCacheAsBitmap:uint;
		private var _hasBlendMode:uint;
		private var _hasFilterList:uint;
		
		private var _className:String;
		private var _filterList:FilterList;
		private var _blendMode:uint;
		private var _bitmapCache:uint;
		
		/**
		 * 构造函数
		 * create a [PlaceObject3Tag] object
		 */
		public function PlaceObject3Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			super.decodeTag(decoder);
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			super.encodeTag(encoder);
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";
		}

		/**
		 * Name of the class to place
		 */		
		public function get className():String { return _className; }

		/**
		 * List of filters on this object
		 */		
		public function get filterList():FilterList { return _filterList; }

		/**
		 * layer blend mode
		 */		
		public function get blendMode():uint { return _blendMode; }

		/**
		 * 0 = Bitmap cache disabled
		 * 1-255 = Bitmap cache enabled
		 */		
		public function get bitmapCache():uint { return _bitmapCache; }

	}
}