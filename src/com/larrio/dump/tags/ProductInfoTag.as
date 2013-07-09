package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 产品信息TAG
	 * @author larryhou
	 * @createTime Jul 9, 2013 4:18:28 PM
	 */
	public class ProductInfoTag extends SWFTag
	{
		public static const TYPE:uint = TagType.PRODUCT_INFO;
		
		private var _product:uint;
		private var _edition:uint;
		private var _majorVersion:uint;
		private var _minorVersion:uint;
		
		private var _majorBuildVersion:uint;
		private var _minorBuildVersion:uint;
		
		private var _compilationTime:Number;
		
		/**
		 * 构造函数
		 * create a [ProductInfoTag] object
		 */
		public function ProductInfoTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_product = decoder.readUI32();
			_edition = decoder.readUI32();
			
			_majorVersion = decoder.readUI8();
			_minorVersion = decoder.readUI8();
			
			_minorBuildVersion = decoder.readUI32();			
			_majorBuildVersion = decoder.readUI32();
			
			_compilationTime = (decoder.readUI32() / 1000 + (decoder.readUI32() << 22) * 1.024) * 1000;
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI32(_product);
			encoder.writeUI32(_edition);
			encoder.writeUI8(_majorVersion);
			encoder.writeUI8(_minorVersion);
			encoder.writeUI32(_minorBuildVersion);
			encoder.writeUI32(_majorBuildVersion);
			encoder.writeUI32(_compilationTime & 0xFFFFFFFF);
			encoder.writeUI32(_compilationTime >> 32);
		}
				
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ProductInfoTag/>");
			result.@product = getProduct();
			result.@edition = getEdition();
			result.@version = _majorVersion + "." + _minorVersion + "." + _majorBuildVersion + "." + _minorBuildVersion;
			result.@compilationTime = new Date(_compilationTime).toString();
			return result.toXMLString();	
		}
		
		private function getEdition():String
		{
			switch (_edition)
			{
				case 0: return "Developer Edition";
				case 1: return "Full Commercial Edition";
				case 2: return "Non-Commercial Edition";
				case 3: return "Educational Edition";
				case 4: return "Not For Resale (NFR) Edition";
				case 5: return "Trial Edition";
			}
			
			return "none";
		}
		
		private function getProduct():String
		{
			switch (_product)
			{
				case 1: return "Macromedia Flex for J2EE";
				case 2: return "Macromedia Flex for .NET";
				case 2: return "Adobe Flex";
			}
			
			return "unknown";
		}

		/**
		 * 产品标识
		 */		
		public function get product():uint { return _product; }

		/**
		 * 产品发行版本
		 */		
		public function get edition():uint { return _edition; }

		/**
		 * 产品大版本号
		 */		
		public function get majorVersion():uint { return _majorVersion; }

		/**
		 * 产品小版本号
		 */		
		public function get minorVersion():uint { return _minorVersion; }

		/**
		 * 产品build版本号
		 */		
		public function get majorBuildVersion():uint { return _majorBuildVersion; }
		
		/**
		 * 产品build版本号
		 */		
		public function get minorBuildVersion():uint { return _minorBuildVersion; }

		/**
		 * 编译时间：毫秒
		 */		
		public function get compilationTime():Number { return _compilationTime; }
		
	}
}