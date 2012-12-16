package com.larrio.dump.model
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * SWF头文件信息
	 * @author larryhou
	 * @createTime Dec 15, 2012 6:33:14 PM
	 */
	public class FileHeader implements ICodec
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
		 * create a [Header] object
		 */
		public function FileHeader()
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
			_compressed = _signature != "F";
			
			_signature += String.fromCharCode(decoder.readUI8());
			_signature += String.fromCharCode(decoder.readUI8());
			
			_version = decoder.readUI8();
			
			_length = decoder.readEU32();
			
			_size = new SWFRect();
			_size.decode(decoder);
			
			_frameRate = decoder.readUI16();
			_frameCount = decoder.readUI16();
		}

		/**
		 * 标记SWF是否被压缩
		 */		
		public function get compressed():Boolean { return _compressed; }

	}
}