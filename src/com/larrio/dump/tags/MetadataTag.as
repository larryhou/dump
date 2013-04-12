package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 4:48:41 PM
	 */
	public class MetadataTag extends SWFTag
	{
		public static const TYPE:uint = TagType.META_DATA;
		
		/**
		 * metadata字符串
		 */		
		public var metadata:String;
		
		/**
		 * 构造函数
		 * create a [MetadataTag] object
		 */
		public function MetadataTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			metadata = decoder.readSTR();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeSTR(metadata);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<MetadataTag>" + metadata + "</MetadataTag>");
			return result.toXMLString();
		}

	}
}