package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.ClipActions;
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
			_hasMaskDepth = decoder.readUB(1);
			_hasName = decoder.readUB(1);
			_hasRatio = decoder.readUB(1);
			_hasColorTransform = decoder.readUB(1);
			_hasMatrix = decoder.readUB(1);
			_hasCharacter = decoder.readUB(1);
			_moved = decoder.readUB(1);
			
			assertTrue(decoder.readUB(3) == 0);
			
			_hasImage = decoder.readUB(1);
			_hasClassName = decoder.readUB(1);
			_hasCacheAsBitmap = decoder.readUB(1);
			_hasBlendMode = decoder.readUB(1);
			_hasFilterList = decoder.readUB(1);
			
			depth = decoder.readUI16();
			
			if (_hasClassName)
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
				_morphRatio = decoder.readUI16();
			}
			
			if (_hasName)
			{
				_name = decoder.readSTR();
			}
			
			if (_hasMaskDepth)
			{
				_maskDepth = decoder.readUI16();
			}
			
			if (_hasFilterList)
			{
				_filterList = new FilterList();
				_filterList.decode(decoder);
			}
			
			if (_hasBlendMode)
			{
				_blendMode = decoder.readUI8();
			}
			
			if (_hasCacheAsBitmap)
			{
				_bitmapCache = decoder.readUI8();
			}
			
			if (_hasClipActions)
			{
				_clipActions = new ClipActions();
				_clipActions.decode(decoder);
			}
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUB(_hasClipActions, 1);
			encoder.writeUB(_hasMaskDepth, 1);
			encoder.writeUB(_hasName, 1);
			encoder.writeUB(_hasRatio, 1);
			encoder.writeUB(_hasColorTransform, 1);
			encoder.writeUB(_hasMatrix, 1);
			encoder.writeUB(_hasCharacter, 1);
			encoder.writeUB(_moved, 1);
			
			encoder.writeUB(0, 3);
			
			encoder.writeUB(_hasImage, 1);
			encoder.writeUB(_hasClassName, 1);
			encoder.writeUB(_hasCacheAsBitmap, 1);
			encoder.writeUB(_hasBlendMode, 1);
			encoder.writeUB(_hasFilterList, 1);
			
			encoder.writeUI16(depth);
			
			if (_hasClassName)
			{
				encoder.writeSTR(_className);
			}
			
			if (_hasCharacter)
			{
				encoder.writeUI16(_character);
			}
			
			if (_hasMatrix)
			{
				_matrix.encode(encoder);
			}
			
			if (_hasColorTransform)
			{
				_colorTransform.encode(encoder);
			}
			
			if (_hasRatio)
			{
				encoder.writeUI16(_morphRatio);
			}
			
			if (_hasName)
			{
				encoder.writeSTR(_name);
			}
			
			if (_hasMaskDepth)
			{
				encoder.writeUI16(_maskDepth);
			}
			
			if (_hasFilterList)
			{
				_filterList.encode(encoder);
			}
			
			if (_hasBlendMode)
			{
				encoder.writeUI8(_blendMode);
			}
			
			if (_hasCacheAsBitmap)
			{
				encoder.writeUI8(_bitmapCache);
			}
			
			if (_hasClipActions)
			{
				_clipActions.encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML(super.toString().replace(/PlaceObject(\d+)?Tag/gs, "PlaceObject3Tag"));
			if (_hasClassName)
			{
				result.@className = _className;
			}
			
			if (_hasFilterList)
			{
				result.appendChild(new XML(_filterList.toString()));
			}
			
			if (_hasBlendMode)
			{
				result.@blendMode = _blendMode;
			}
			
			if (_hasCacheAsBitmap)
			{
				result.@bitmapCache = this.bitmapCache;
			}
			
			return result.toXMLString();
		}

		/**
		 * Name of the class to place
		 * 
		 * The PlaceFlagHasClassName field indicates that a class name will be specified, indicating the type of object to place.
		 * Because we no longer use ImportAssets in ActionScript 3.0, 
		 * there needed to be some way to place a Timeline object using a class imported from another SWF, 
		 * which does not have a 16-bit character ID in the instantiating SWF. Supported in Flash Player 9.0.45.0 and later.
		 */		
		public function get className():String { return _className; }
		public function set className(value:String):void
		{
			_className = value;
			_hasClassName = 1;
		}

		/**
		 * List of filters on this object
		 */		
		public function get filterList():FilterList { return _filterList; }
		public function set filderList(value:FilterList):void
		{
			_filterList = value;
			_hasFilterList = 1;
		}

		/**
		 * layer blend mode
		 */		
		public function get blendMode():uint { return _blendMode; }
		public function set blendMode(value:uint):void
		{
			_blendMode = _blendMode;
			_hasBlendMode = 1;
		}

		/**
		 * 0 = Bitmap cache disabled
		 * 1-255 = Bitmap cache enabled
		 * The PlaceFlagHasCacheAsBitmap field specifies whether Flash Player should internally cache a display object as a bitmap. 
		 * Caching can speed up rendering when the object does not change frequently.
		 */		
		public function get bitmapCache():Boolean { return Boolean(_bitmapCache); }
		public function set bitmapCache(value:Boolean):void
		{
			_bitmapCache = uint(value);
		}
		
		/**
		 * The PlaceFlagHasImage field indicates the creation of native Bitmap objects on the display list. 
		 * When PlaceFlagHasClassName and PlaceFlagHasImage are both defined, 
		 * this indicates a Bitmap class to be loaded from another SWF. 
		 * Immediately following the flags is the class name (as above) for the BitmapData class in the loaded SWF. 
		 * A Bitmap object will be placed with the named BitmapData class as it's internal data. 
		 * When PlaceFlagHasCharacter and PlaceFlagHasImage are both defined, this indicates a Bitmap from the current SWF. 
		 * The BitmapData to be used as its internal data will be defined by the following characterID. 
		 * This only occurs when the BitmapData has a class associated with it. 
		 * If there is no class associated with the BitmapData, DefineShape should be used with a Bitmap fill. 
		 * Supported in Flash Player 9.0.45.0 and later.
		 */		
		public function get hasImage():Boolean { return Boolean(_hasImage); }
		public function set hasImage(value:Boolean):void
		{
			_hasImage = uint(value);
		}
	}
}