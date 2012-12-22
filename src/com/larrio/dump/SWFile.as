package com.larrio.dump
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFHeader;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagFactory;
	
	import flash.utils.ByteArray;
	
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
		
		/**
		 * 构造函数
		 * create a [SWFile] object
		 */
		public function SWFile(bytes:ByteArray)
		{
			// 写入文件二进制已编码字节
			_decoder = new FileDecoder();
			_decoder.writeBytes(bytes);
			_decoder.position = 0;
			
			decode();
		}
		
		/**
		 * 二进制编码 
		 */		
		public function encode():ByteArray
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
		 * 二进制解码 
		 */		
		private function decode():void
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
				tag.decode(_decoder);
				
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

	}
}