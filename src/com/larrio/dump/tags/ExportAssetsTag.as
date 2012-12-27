package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 11:07:08 PM
	 */
	public class ExportAssetsTag extends SWFTag
	{
		public static const TYPE:uint = TagType.EXPORT_ASSETS;
		
		protected var _ids:Vector.<uint>;
		protected var _names:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [ExportAssetsTag] object
		 */
		public function ExportAssetsTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			var length:uint, i:int;
			
			length = decoder.readUI16();
			
			_ids = new Vector.<uint>(length, true);
			_names = new Vector.<String>(length, true);
			
			for (i = 0; i < length; i++)
			{
				_ids[i] = decoder.readUI16();
				_names[i] = decoder.readSTR();
			}
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			var length:uint, i:int;
			
			length = _ids.length;
			encoder.writeUI16(length);
			
			for (i = 0; i < length; i++)
			{
				encoder.writeUI16(_ids[i]);
				encoder.writeSTR(_names[i]);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ExportAssetsTag/>");
			
			var item:XML;
			var length:uint = _ids.length;
			for (var i:int = 0; i < length; i++)
			{
				item = new XML("<asset/>");
				item.@id = _ids[i];
				item.@name = _names[i];
				result.appendChild(item);
			}
			
			return result.toXMLString();	
		}

		/**
		 * charactor id
		 */		
		public function get ids():Vector.<uint> { return _ids; }

		/**
		 * identifiers
		 */		
		public function get names():Vector.<String> { return _names; }

		
	}
}