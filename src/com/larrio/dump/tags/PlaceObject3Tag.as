package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.ColorTransformRecord;
	import com.larrio.dump.model.FilterList;
	import com.larrio.dump.model.MatrixRecord;
	import com.larrio.dump.utils.assertTrue;
	
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
			_hasClipActions = decoder.readUB(1);
			_hasClipDepth = decoder.readUB(1);
			_hasName = decoder.readUB(1);
			_hasRatio = decoder.readUB(1);
			_hasColorTransform = decoder.readUB(1);
			_hasMatrix = decoder.readUB(1);
			_hasCharacter = decoder.readUB(1);
			_move = decoder.readUB(1);
			
			assertTrue(decoder.readUB(3) == 0);
			
			_hasImage = decoder.readUB(1);
			_hasClassName = decoder.readUB(1);
			_hasCacheAsBitmap = decoder.readUB(1);
			_hasBlendMode = decoder.readUB(1);
			_hasFilterList = decoder.readUB(1);
			
			_depth = decoder.readUI16();
			
			if (_hasClassName || (_hasImage && _hasCharacter))
			{
				_className = decoder.readSTR();
			}
			
			if (_hasCharacter)
			{
				_character = decoder.readUI16();
			}
			
			if (_hasMatrix)
			{
				_matrix = new MatrixRecord();
				_matrix.decode(decoder);
			}
			
			if (_hasColorTransform)
			{
				_colorTransform = new ColorTransformRecord(true);
				_colorTransform.decode(decoder);
			}
			
			if (_hasRatio)
			{
				_ratio = decoder.readUI16();
			}
			
			if (_hasName)
			{
				_name = decoder.readSTR();
			}
			
			if (_hasClipDepth)
			{
				_clipDepth = decoder.readUI16();
			}
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
		override public function toString():String
		{
			var result:XML = new XML(super.toString().replace(/PlaceObject(\d+)?Tag/gs, "PlaceObject3Tag"));
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