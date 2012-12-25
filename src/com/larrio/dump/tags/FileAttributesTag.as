package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.flash_proxy;
	
	/**
	 * 文件属性TAG
	 * @author larryhou
	 * @createTime Dec 16, 2012 2:28:46 PM
	 */
	public class FileAttributesTag extends SWFTag
	{
		public static const TYPE:uint = TagType.FILE_ATTRIBUTES;
		
		private var _blit:Boolean;
		
		private var _gpu:Boolean;
		
		private var _metadata:Boolean;
		
		private var _as3:Boolean;
		
		private var _network:Boolean;
		
		/**
		 * 构造函数
		 * create a [FileAttributesTag] object
		 */
		public function FileAttributesTag()
		{
			
		}
				
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == FileAttributesTag.TYPE);
			
			decoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			assertTrue(decoder.readUB(1) == 0);
			
			_blit = Boolean(decoder.readUB(1));
			_gpu = Boolean(decoder.readUB(1));
			_metadata = Boolean(decoder.readUB(1));
			_as3 = Boolean(decoder.readUB(1));
			
			assertTrue(decoder.readUB(2) == 0);
			
			_network = Boolean(decoder.readUB(1));
			
			assertTrue(decoder.readUB(24) == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			encoder.writeUB(0, 1);
			
			encoder.writeUB(int(_blit), 1);
			encoder.writeUB(int(_gpu), 1);
			encoder.writeUB(int(_metadata), 1);
			encoder.writeUB(int(_as3), 1);
			
			encoder.writeUB(0, 2);
			
			encoder.writeUB(int(_network), 1);
			
			encoder.writeUB(0, 24);
			encoder.flush();
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var item:XML;
			var result:XML = new XML("<FileAttributesTag/>");
			
			result.@blit = _blit;
			result.@gpu = _gpu;
			result.@metadata = _metadata;
			result.@as3 = _as3;
			result.@network = _network;
			
			return result.toXMLString();
		}

		/**
		 * 是否使用硬件加速
		 */		
		public function get blit():Boolean { return _blit; }

		/**
		 * 是有使用GPU加速
		 */		
		public function get gpu():Boolean { return _gpu; }

		/**
		 * 是否有metadata
		 */		
		public function get metadata():Boolean { return _metadata; }

		/**
		 * 是否为ActionScript3语言
		 */		
		public function get as3():Boolean { return _as3; }

		/**
		 * 是否可以访问网络资源
		 */		
		public function get network():Boolean { return _network; }
		
	}
}