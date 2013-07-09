package com.larrio.dump.tags.creators.binary
{
	import com.larrio.dump.doabc.templates.binary.BinaryDoABC;
	import com.larrio.dump.tags.DefineBinaryDataTag;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 9, 2013 1:08:29 PM
	 */
	public class BinaryTagCreator
	{
		private var _classTag:DoABCTag;
		private var _assetTag:DefineBinaryDataTag;
		
		/**
		 * 构造函数
		 * create a [BinaryTagCreator] object
		 */
		public function BinaryTagCreator(bytes:ByteArray, name:String)
		{
			_classTag = new BinaryDoABC(name).tag;
			
			_assetTag = new DefineBinaryDataTag();
			_assetTag.character = 0;	// 预留字段
			_assetTag.data = bytes;
		}

		/**
		 * 二进制数据导出类TAG
		 */		
		public function get classTag():DoABCTag { return _classTag; }

		/**
		 * 二进制数据TAG
		 */		
		public function get assetTag():DefineBinaryDataTag { return _assetTag; }
	}
}