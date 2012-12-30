package com.larrio.dump.model.fonts
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.math.float;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 4:12:52 PM
	 */
	public class ZoneData implements ICodec
	{
		private var _coordinate:uint;
		private var _range:uint;
		
		/**
		 * 构造函数
		 * create a [ZoneData] object
		 */
		public function ZoneData()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_coordinate = decoder.readUI16();
			_range = decoder.readUI16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI16(_coordinate);
			encoder.writeUI16(_range);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ZoneData/>");
			result.@coordinate = float(_coordinate, 16, 5, 16);
			result.@range = float(_range, 16, 5, 16);
			return result.toXMLString();	
		}

		/**
		 * X (left) or Y (baseline) coordinate of the alignment zone.
		 */		
		public function get coordinate():uint { return _coordinate; }

		/**
		 * Width or height of the alignment zone.
		 */		
		public function get range():uint { return _range; }

	}
}