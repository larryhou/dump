package com.larrio.dump
{
	import avmplus.USE_ITRAITS;
	
	import com.larrio.dump.doabc.templates.audio.MP3DoABC;
	import com.larrio.dump.doabc.templates.image.ImageDoABC;
	import com.larrio.dump.model.SWFHeader;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.tags.DefineBitsLosslessTag;
	import com.larrio.dump.tags.DefineBitsTag;
	import com.larrio.dump.tags.DefineSoundTag;
	import com.larrio.dump.tags.DoABCTag;
	import com.larrio.dump.tags.EndTag;
	import com.larrio.dump.tags.FileAttributesTag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.ShowFrameTag;
	import com.larrio.dump.tags.SymbolClassTag;
	import com.larrio.dump.tags.creators.audio.MP3TagCreator;
	import com.larrio.dump.tags.creators.binary.BinaryTagCreator;
	import com.larrio.dump.tags.creators.image.ImageTagCreator;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 11:17:42 AM
	 */
	public class SWFBuilder
	{
		private var _assets:Vector.<AssetItem>;
		
		/**
		 * 构造函数
		 * create a [SWFBuilder] object
		 */
		public function SWFBuilder()
		{
			_assets = new Vector.<AssetItem>();
		}
		
		private function createHeader():SWFHeader
		{
			var header:SWFHeader = new SWFHeader();
			header.compressed = true;
			header.frameCount = 1;
			header.frameRate = 24 << 8;
			header.size = new SWFRect();
			header.size.maxX = 400 * 20;
			header.size.maxY = 300 * 20;
			header.version = 0x0A;
			
			return header;
		}
		
		private function createFileAttributesTag():FileAttributesTag
		{
			var tag:FileAttributesTag = new FileAttributesTag();
			tag.network = true;
			tag.metadata = false;
			tag.as3 = true;
			
			return tag;
		}
		
		private function createShowFrameTag():ShowFrameTag
		{
			return new ShowFrameTag();
		}
		
		private function createEndTag():EndTag
		{
			return new EndTag();
		}
		
		/**
		 * 嵌入MP3素材文件 
		 * @param bytes	MP3字节码
		 * @param name	MP3导出类: package::ClassName
		 */		
		public function insertMP3(bytes:ByteArray, name:String):void
		{
			var creator:MP3TagCreator = new MP3TagCreator(bytes, name);
			var asset:AssetItem = new AssetItem(name, creator.classTag, creator.assetTag);
			
			_assets.push(asset);
		}
		
		/**
		 * 嵌入JPEG 
		 * @param bytes	图片二进制文件
		 * @param name	图片导出类: package::ClassName
		 */		
		public function insertImage(bytes:ByteArray, name:String):void
		{
			var creator:ImageTagCreator = new ImageTagCreator(bytes, name);
			var asset:AssetItem = new AssetItem(name, creator.classTag, creator.assetTag);
			
			_assets.push(asset);
		}
		
		/**
		 * 插入图片素材TAG
		 * @param tag	DefineBitsTag | DefineLosslessTag
		 * @param name	图片素材导入类名: package::ClassName
		 */		
		public function insertImageByTag(tag:SWFTag, name:String):void
		{
			if (tag is DefineBitsTag || tag is DefineBitsLosslessTag)
			{
				var asset:AssetItem = new AssetItem(name, new ImageDoABC(name).tag, tag);
				_assets.push(asset);
			}
		}
		
		/**
		 * 嵌入二进制文件 
		 * @param bytes	二进制文件
		 * @param name	导出链接名
		 */		
		public function insertBinary(bytes:ByteArray, name:String):void
		{
			var creator:BinaryTagCreator = new BinaryTagCreator(bytes, name);
			var asset:AssetItem = new AssetItem(name, creator.classTag, creator.assetTag);
			
			_assets.push(asset);
		}
		
		/**
		 * 导出SWF文件
		 */		
		public function export():ByteArray
		{
			var swf:SWFile = new SWFile(null);
			swf.header = createHeader();
			
			swf.tags = new Vector.<SWFTag>;
			swf.tags.push(createFileAttributesTag());
			
			// 插入素材
			var classTags:Vector.<DoABCTag> = new Vector.<DoABCTag>;
			var assetTags:Vector.<SWFTag> = new Vector.<SWFTag>;
			
			// 处理链接名
			var symbol:SymbolClassTag = new SymbolClassTag();
			symbol.symbols = new Vector.<String>;
			symbol.ids = new Vector.<uint>;
			
			var item:AssetItem;
			for (var i:int = 0; i < _assets.length; i++)
			{
				item = _assets[i];
				classTags.push(item.classTag);
				assetTags.push(item.assetTag);
				item.assetTag.character = i + 1;
				
				symbol.ids.push(item.assetTag.character);
				symbol.symbols.push(item.name.replace("::", "."));
			}
			
			// 素材列表
			swf.tags = swf.tags.concat(assetTags);
			
			// 类定义
			swf.tags = swf.tags.concat(classTags);
			
			// 链接名
			swf.tags.push(symbol);
			
			// 封包
			swf.tags.push(createShowFrameTag());
			swf.tags.push(createEndTag());
			
			return swf.repack();
		}
	}
}
import com.larrio.dump.tags.DoABCTag;
import com.larrio.dump.tags.SWFTag;

class AssetItem
{
	public var classTag:DoABCTag;
	public var assetTag:SWFTag;
	public var name:String;
	
	public function AssetItem(name:String, classTag:DoABCTag, assetTag:SWFTag)
	{
		this.name = name;
		this.classTag = classTag;
		this.assetTag = assetTag;
	}
}