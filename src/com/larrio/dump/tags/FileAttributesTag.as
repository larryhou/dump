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
		
		/**
		 * 是否使用硬件加速
		 */		
		public var blit:Boolean;
		
		/**
		 * 是有使用GPU加速
		 */	
		public var gpu:Boolean;
		
		/**
		 * 是否有metadata
		 */	
		public var metadata:Boolean;
		
		/**
		 * 是否为ActionScript3语言
		 */	
		public var as3:Boolean;
		
		/**
		 * 是否可以访问网络资源
		 */
		public var network:Boolean;
		
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
		override protected function decodeTag(decoder:FileDecoder):void
		{
			assertTrue(decoder.readUB(1) == 0);
			
			blit = Boolean(decoder.readUB(1));
			gpu = Boolean(decoder.readUB(1));
			metadata = Boolean(decoder.readUB(1));
			as3 = Boolean(decoder.readUB(1));
			
			assertTrue(decoder.readUB(2) == 0);
			
			network = Boolean(decoder.readUB(1));
			
			assertTrue(decoder.readUB(24) == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUB(0, 1);
			
			encoder.writeUB(int(blit), 1);
			encoder.writeUB(int(gpu), 1);
			encoder.writeUB(int(metadata), 1);
			encoder.writeUB(int(as3), 1);
			
			encoder.writeUB(0, 2);
			
			encoder.writeUB(int(network), 1);
			
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
			
			result.@blit = blit;
			result.@gpu = gpu;
			result.@metadata = metadata;
			result.@as3 = as3;
			result.@network = network;
			
			return result.toXMLString();
		}		
	}
}