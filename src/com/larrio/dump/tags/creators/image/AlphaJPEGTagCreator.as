package com.larrio.dump.tags.creators.image
{
	import com.larrio.dump.doabc.templates.image.ImageDoABC;
	import com.larrio.dump.tags.DefineBitsJPEG3Tag;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 10, 2013 11:41:08 AM
	 */
	public class AlphaJPEGTagCreator
	{
		private var _classTag:DoABCTag;
		private var _assetTag:DefineBitsJPEG3Tag;
		
		/**
		 * 构造函数
		 * create a [AlphaJPEGTagCreator] object
		 */
		public function AlphaJPEGTagCreator(bytes:ByteArray, alphaBytes:ByteArray, name:String)
		{
			_classTag = new ImageDoABC(name).tag;
			
			_assetTag = new DefineBitsJPEG3Tag();
			
			_assetTag.data = bytes;
			_assetTag.bitmapAlphaData = alphaBytes;
		}

		/**
		 * 图片素材TAG
		 */		
		public function get assetTag():DefineBitsJPEG3Tag { return _assetTag; }

		/**
		 * 图片导出类TAG
		 */		
		public function get classTag():DoABCTag { return _classTag; }
	}
}