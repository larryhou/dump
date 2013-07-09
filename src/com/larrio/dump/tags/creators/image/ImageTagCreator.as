package com.larrio.dump.tags.creators.image
{
	import com.larrio.dump.doabc.templates.image.ImageDoABC;
	import com.larrio.dump.tags.DefineBitsJPEG2Tag;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 3:51:09 PM
	 */
	public class ImageTagCreator
	{
		private var _classTag:DoABCTag;
		private var _assetTag:DefineBitsJPEG2Tag;

		/**
		 * 构造函数
		 * create a [ImageTagCreator] object
		 */
		public function ImageTagCreator(bytes:ByteArray, name:String)
		{
			_classTag = new ImageDoABC(name).tag;
			
			_assetTag = new DefineBitsJPEG2Tag();
			_assetTag.character = 0;	// 预留字段
			_assetTag.data = bytes;
		}

		/**
		 * 图片对应链接名TAG
		 */		
		public function get classTag():DoABCTag { return _classTag; }

		/**
		 * 图片素材TAG
		 */		
		public function get assetTag():DefineBitsJPEG2Tag { return _assetTag; }

	}
}