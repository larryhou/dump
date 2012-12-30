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
		
		private var _symbol:SymbolClassTag;
		
		private var _map:Dictionary;
		
		/**
		 * 构造函数
		 * create a [SWFile] object
		 */
		public function SWFile(bytes:ByteArray)
		{
			_map = new Dictionary(true);
			
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
			
			var position:uint;
			var tag:SWFTag, type:uint;
			while (_decoder.bytesAvailable)
			{
				position = _decoder.position;
				type = _decoder.readUI16() >>> 6;
				_decoder.position = position;
				
				tag = TagFactory.create(type);
				tag.map = _map;
				
				tag.decode(_decoder);
				
				if (tag.type == TagType.SYMBOL_CLASS)
				{
					_symbol = tag as SymbolClassTag;
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
		public function get symbol():SymbolClassTag { return _symbol; }

	}
}