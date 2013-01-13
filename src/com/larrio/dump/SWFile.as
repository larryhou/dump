package com.larrio.dump
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFHeader;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.SymbolClassTag;
	import com.larrio.dump.tags.TagFactory;
	import com.larrio.dump.tags.TagType;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * SWF文件
	 * @author larryhou
	 * @createTime Dec 15, 2012 6:18:33 PM
	 */
	public class SWFile
	{
		// 编码工具
		private var _encoder:FileEncoder;
		
		// 解码工具
		private var _decoder:FileDecoder;
		
		// SWF头信息
		private var _header:SWFHeader;
		
		private var _tags:Vector.<SWFTag>;
		
		private var _symbolTags:Vector.<SymbolClassTag>;
		
		private var _dict:Dictionary;
		private var _include:Dictionary;
		
		/**
		 * 构造函数
		 * create a [SWFile] object
		 * @param bytes		SWF文件二进制数据
		 * @param includes	自定义需要解析的TAG类型列表，默认解析所有TAG；设定该参数可以提高SWF解析速度
		 */		
		public function SWFile(bytes:ByteArray, includes:Array = null)
		{
			_dict = new Dictionary(true);
			if (includes)
			{
				// 保证控制TAG被解析
				includes.push(TagType.SET_BACKGROUND_COLOR);
				includes.push(TagType.FRAME_LABEL);
				includes.push(TagType.PROTECT);
				includes.push(TagType.END);
				includes.push(TagType.EXPORT_ASSETS);
				includes.push(TagType.IMPORT_ASSETS);
				includes.push(TagType.IMPORT_ASSETS2);
				includes.push(TagType.ENABLE_DEBUGGER);
				includes.push(TagType.ENABLE_DEBUGGER2);
				includes.push(TagType.SCRIPT_LIMITS);
				includes.push(TagType.SET_TABLE_INDEX);
				includes.push(TagType.FILE_ATTRIBUTES);
				includes.push(TagType.SYMBOL_CLASS);
				includes.push(TagType.META_DATA);
				includes.push(TagType.DEFINE_SCALING_GRID);
				includes.push(TagType.DEFINE_SCENE_AND_FRAME_LABEL_DATA);
				
				_include = new Dictionary(true);
				for each (var type:uint in includes) _include[type] = true;
			}
			
			// 写入文件二进制已编码字节
			_decoder = new FileDecoder();
			_decoder.writeBytes(bytes);
			_decoder.position = 0;
			
			unpack();
		}
		
		/**
		 * 重新打包SWF二进制文件 
		 */		
		public function repack():ByteArray
		{
			var length:int;
			var content:FileEncoder;
			
			content = new FileEncoder();
			
			_header.size.encode(content);
			
			content.writeUI16(_header.frameRate);
			content.writeUI16(_header.frameCount);
			
			length = _tags.length;
			for (var i:int = 0; i < length; i++)
			{
				_tags[i].encode(content);
			}
			
			// SWF二进制封包
			_encoder = new FileEncoder();
			
			_header.encode(_encoder);
			
			// 写入压缩前的总字节长度
			_encoder.writeUI32(_encoder.length + 4 + content.length);
			_header.compressed && content.compress();
			_encoder.writeBytes(content);
			
			// 打包输出
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes(_encoder);
			bytes.position = 0;
			
			return bytes;
		}
		
		/**
		 * SWF二进制解包
		 */		
		private function unpack():void
		{
			_decoder.position = 0;
			
			_header = new SWFHeader();
			_header.decode(_decoder);
			
			_tags = new Vector.<SWFTag>;
			_symbolTags = new Vector.<SymbolClassTag>();
			
			var position:uint;
			var tag:SWFTag, type:uint;
			while (_decoder.bytesAvailable)
			{
				position = _decoder.position;
				type = _decoder.readUI16() >>> 6;
				_decoder.position = position;
				
				if (!_include || _include[type])
				{
					tag = TagFactory.create(type);
				}
				else
				{
					tag = new SWFTag();
				}
				
				tag.dict = _dict;
				
				tag.decode(_decoder);
				
				if (tag.type == TagType.SYMBOL_CLASS)
				{
					_symbolTags.push(tag as SymbolClassTag);
				}
				
				_tags.push(tag);
			}
		}

		/**
		 * SWF头信息
		 */		
		public function get header():SWFHeader { return _header; }

		/**
		 * SWF文件TAG数组
		 */		
		public function get tags():Vector.<SWFTag> { return _tags; }

		/**
		 * SWF链接名TAG
		 */		
		public function get symbolTags():Vector.<SymbolClassTag> { return _symbolTags; }

	}
}