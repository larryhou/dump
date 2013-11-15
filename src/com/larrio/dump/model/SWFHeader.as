package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.compress.CompressMethods;
	import com.larrio.dump.compress.uncompressSWF;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.math.fixed;
	
	import flash.utils.ByteArray;
	
	/**
	 * SWF头文件信息
	 * @author larryhou
	 * @createTime Dec 15, 2012 6:33:14 PM
	 */
	public class SWFHeader implements ICodec
	{
		private var _signature:String;
		private var _version:uint;
		
		private var _length:uint;
		private var _size:SWFRect;
		private var _frameRate:uint;
		private var _frameCount:uint;
		
		/**
		 * 构造函数
		 * create a [SWFHeader] object
		 */
		public function SWFHeader()
		{
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUTFBytes(_signature);
			encoder.writeUI8(_version);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_signature = decoder.readUTFBytes(3);
			
			_version = decoder.readUI8();			
			_length = decoder.readUI32();
			
			var bytes:ByteArray;
			var position:uint = decoder.position;
			
			if (compressMethod != CompressMethods.NONE)
			{
				bytes = new ByteArray();
				decoder.readBytes(bytes);
				
				bytes.position = 0;
				uncompressSWF(bytes, compressMethod, _length);
				
				decoder.position = position;
				decoder.writeBytes(bytes);
				decoder.position = position;
			}
			
			assertTrue(_length == decoder.length, "文件格式损坏！");
			assertTrue(decoder.position == 8, "头信息前8字节解析错误！");
			
			_size = new SWFRect();
			_size.decode(decoder);
			
			_frameRate = decoder.readUI16();
			_frameCount = decoder.readUI16();
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<Header/>");
			result.@signature = _signature;
			result.@version = _version;
			result.@width = _size.width;
			result.@height = _size.height;
			result.@frameRate = fixed(_frameRate, 8, 8);
			result.@frameCount = _frameCount;
			result.@size = _length;
			
			return result.toXMLString();
		}

		/**
		 * SWF头文件标记
		 */		
		public function get signature():String { return _signature; }

		/**
		 * SWF版本号
		 */		
		public function get version():uint { return _version; }
		public function set version(value:uint):void
		{
			_version = value;
		}

		/**
		 * 解压后的总长度：包含头文件长度
		 */		
		public function get length():uint { return _length; }

		/**
		 * SWF尺寸大小
		 */		
		public function get size():SWFRect { return _size; }
		public function set size(value:SWFRect):void
		{
			_size = value;
		}

		/**
		 * SWF帧率：8.8 FIXED number
		 */		
		public function get frameRate():uint { return _frameRate; }
		public function set frameRate(value:uint):void
		{
			_frameRate = value;
		}

		/**
		 * SWF总帧数
		 */		
		public function get frameCount():uint { return _frameCount; }
		public function set frameCount(value:uint):void
		{
			_frameCount = value;
		}

		/**
		 * 设置压缩方式
		 */		
		public function get compressMethod():String { return _signature; }
		public function set compressMethod(value:String):void
		{
			if (!value || !value.match(/^[FCZ]WS$/i))
			{
				_signature = CompressMethods.ZLIB;
			}
			else
			{
				_signature = value.toUpperCase();
			}
		}
	}
}