package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 11:24:27 PM
	 */
	public class ImportAssets2Tag extends SWFTag
	{
		public static const TYPE:uint = TagType.IMPORT_ASSETS2;
		
		private var _url:String;
		
		private var _ids:Vector.<uint>;
		private var _names:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [ImportAssets2Tag] object
		 */
		public function ImportAssets2Tag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_url = decoder.readSTR();
			
			assertTrue(decoder.readUI8() == 1);
			assertTrue(decoder.readUI8() == 0);
			
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
			encoder.writeSTR(_url);
			
			encoder.writeUI8(1);
			encoder.writeUI8(0);
			
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
			var result:XML = new XML("<ImportAssets2Tag/>");
			result.@url = _url;
			
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
		 * URL where the source SWF file can be found
		 */		
		public function get url():String { return _url; }

		/**
		 * charactor id
		 */		
		public function get ids():Vector.<uint> { return _ids; }

		/**
		 * identifier
		 */		
		public function get names():Vector.<String> { return _names; }

		
	}
}