package com.larrio.dump.model
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
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
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_signature = String.fromCharCode(decoder.readUI8());			
			_signature += String.fromCharCode(decoder.readUI8());
			_signature += String.fromCharCode(decoder.readUI8());
			
			_compressed = (_signature == "CWS");
			
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
			
			_frameRate = decoder.readUI16();
			_frameCount = decoder.readUI16();
		}

		/**
		 * 标记SWF是否被压缩
		 */		
		public function get compressed():Boolean { return _compressed; }

		/**
		 * SWF头文件标记
		 */		
		public function get signature():String { return _signature; }

		/**
		 * SWF版本号
		 */		
		public function get version():uint { return _version; }

		/**
		 * 解压后的总长度：包含头文件长度
		 */		
		public function get length():uint { return _length; }

		/**
		 * SWF尺寸大小
		 */		
		public function get size():SWFRect { return _size; }

		/**
		 * SWF帧率：8.8 FIXED number
		 */		
		public function get frameRate():uint { return _frameRate; }

		/**
		 * SWF总帧数
		 */		
		public function get frameCount():uint { return _frameCount; }


	}
}