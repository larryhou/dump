package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
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
		
		private var _compressed:Boolean;
		
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
			if (_compressed)
			{
				encoder.writeUI8(("C").charCodeAt(0));
			}
			else
			{
				encoder.writeUI8(("F").charCodeAt(0));
			}
			
			encoder.writeUI8(("W").charCodeAt(0));
			encoder.writeUI8(("S").charCodeAt(0));
			
			encoder.writeUI8(_version);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_signature = String.fromCharCode(decoder.readUI8());
			_compressed = (_signature == "C");
			
			_signature += String.fromCharCode(decoder.readUI8());
			_signature += String.fromCharCode(decoder.readUI8());
			
			_version = decoder.readUI8();			
			_length = decoder.readUI32();
			
			var bytes:ByteArray;
			var position:uint = decoder.position;
			
			if (_compressed)
			{
				bytes = new ByteArray();
				decoder.readBytes(bytes);
				bytes.uncompress();
				
				decoder.position = position;
				decoder.writeBytes(bytes);
				decoder.position = position;
			}
			
			assertTrue(_length == decoder.length, "文件格式损坏！");
			assertTrue(decoder.position == 8, "头信息前8字节解析错误！");
			
			_size = new SWFRect();
			_size.decode(decoder);
			
			assertTrue(_size.minX == 0);
			assertTrue(_size.minY == 0);
			
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
			result.@compressed = _compressed;
			result.@version = _version;
			result.@width = _size.width;
			result.@height = _size.height;
			result.@frameRate = fixed(_frameRate, 8, 8);
			result.@frameCount = _frameCount;
			result.@size = _length;
			
			return result.toXMLString();
		}

		/**
		 * 标记SWF是否被压缩
		 */		
		public function get compressed():Boolean { return _compressed; }
		public function set compressed(value:Boolean):void
		{
			_compressed = value;
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


	}
}