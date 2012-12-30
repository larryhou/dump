package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * TAG抽象类
	 * @author larryhou
	 * @createTime Dec 15, 2012 6:36:43 PM
	 */
	public class SWFTag
	{
		protected static const _map:Dictionary = new Dictionary(true);
		
		protected var _type:uint;
		protected var _character:uint;
		
		protected var _length:int;
		protected var _bytes:ByteArray;
		
		private var _codeAndLength:uint;
		private var _offset:uint;
		
		/**
		 * 构造函数
		 * create a [SWFTag] object
		 */
		public function SWFTag()
		{
			
		}
		
		/**
		 * 对二进制进行解码 
		 * @param codec	编解码数据
		 */		
		public function decode(decoder:FileDecoder):void
		{
			readTagHeader(decoder);
			
			assertTrue(_length >= 0, "TAG[0x" + _type.toString(16).toUpperCase() + "]长度不合法：" + _length);
			
			_bytes = new ByteArray();
			if (_length > 0) 
			{
				decoder.readBytes(_bytes, 0, _length);
			}
			
			assertTrue(_bytes.length == _length);
			
			decoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			decodeTag(decoder);
			if (decoder.position > 0)
			{
				assertTrue(decoder.bytesAvailable == 0);
			}
			
			_offset = decoder.position;
			
			const NAME:String = "TYPE";
			if (NAME in Object(this).constructor)
			{
				assertTrue(_type == Object(this).constructor[NAME]);
			}
		}
		
		/**
		 * 对二进制进行编码
		 * @param codec	编解码数据
		 */		
		public function encode(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			var offset:uint;
			offset = encoder.position;
			
			encodeTag(encoder);
			encoder.flush();
			
			offset = encoder.position - offset;
			assertTrue(offset == _length);
		}
		
		/**
		 * 写入TAG头信息 
		 * @param encoder	编码器
		 */		
		protected final function writeTagHeader(encoder:FileEncoder):void
		{
			if ((_codeAndLength & 0x3F) < 0x3F)
			{
				encoder.writeUI16( _type << 6 | _length);
			}
			else
			{
				encoder.writeUI16( _type << 6 | 0x3F);
				encoder.writeS32(_length);
			}
		}
		
		/**
		 * 对TAG内容进行二进制编码
		 * @param encoder	编码器
		 */		
		protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeBytes(_bytes);
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		protected function decodeTag(decoder:FileDecoder):void
		{
			
		}
		
		/**
		 * 读取TAG头信息 
		 * @param decoder	解码器
		 */		
		protected final function readTagHeader(decoder:FileDecoder):void
		{
			_codeAndLength = decoder.readUI16();
			
			_type = _codeAndLength >>> 6;
			_length = _codeAndLength & 0x3F;
			
			if (_length >= 0x3F)
			{
				_length = decoder.readS32();
			}
		}

		/**
		 * TAG类型
		 */		
		public function get type():uint { return _type; }

		/**
		 * TAG字节数组
		 */		
		public function get bytes():ByteArray { return _bytes; }

		/**
		 * 特征ID
		 */		
		public function get character():uint { return _character; }

	}
}