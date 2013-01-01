package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.dump.utils.hexSTR;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * TAG抽象类
	 * @author larryhou
	 * @createTime Dec 15, 2012 6:36:43 PM
	 */
	public class SWFTag
	{
		protected var _map:Dictionary;
		
		protected var _type:uint;
		protected var _character:uint;
		
		protected var _length:int;
		protected var _bytes:ByteArray;
		
		private var _codeAndLength:uint;
		private var _remain:int;
		
		protected var _skipAssert:Boolean;
		
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
				_remain = decoder.bytesAvailable;
			}
			
			if (_remain > 0)
			{
				var warning:String = getQualifiedClassName(this).split("::")[1];
				trace("#" + warning + "# " + _remain + " UNRESOLVED BYTES:");
				trace(hexSTR(decoder, 4, decoder.position, _remain));
			}
			
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
			var data:FileEncoder;
			
			data = new FileEncoder();
			encodeTag(data);
			data.flush();
			
			if (_skipAssert)
			{
				_length = data.length;
			}
			
			writeTagHeader(encoder);
			encoder.writeBytes(data);
			
			if (!_skipAssert) assertTrue(data.length == _length - _remain);
		}
		
		/**
		 * 写入TAG头信息 
		 * @param encoder	编码器
		 */		
		protected final function writeTagHeader(encoder:FileEncoder):void
		{
			var rlength:uint = _length - _remain;
			if (_remain == 0)
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
			else
			{
				if (rlength < 0x3F)
				{
					encoder.writeUI16(_type << 6 | rlength);
				}
				else
				{
					encoder.writeUI16(_type << 6 | 0x3F);
					encoder.writeS32(rlength);
				}
			}
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

		/**
		 * 映射表
		 */		
		public function get map():Dictionary { return _map; }
		public function set map(value:Dictionary):void
		{
			_map = value;
		}


	}
}