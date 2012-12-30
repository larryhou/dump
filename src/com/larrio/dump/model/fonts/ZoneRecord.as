package com.larrio.dump.model.fonts
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 4:12:12 PM
	 */
	public class ZoneRecord implements ICodec
	{
		private var _datas:Vector.<ZoneData>;
		private var _maskX:uint;
		private var _maskY:uint;
		
		/**
		 * 构造函数
		 * create a [ZoneRecord] object
		 */
		public function ZoneRecord()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			var length:uint, i:int;
			length = decoder.readUI8();
			assertTrue(length == 2);
			
			_datas = new Vector.<ZoneData>(length, true);
			for (i = 0; i < length; i++)
			{
				_datas[i] = new ZoneData();
				_datas[i].decode(decoder);
			}
			
			assertTrue(decoder.readUB(6) == 0);
			
			_maskY = decoder.readUB(1);
			_maskX = decoder.readUB(1);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			var length:uint, i:int;
			length = _datas.length;
			encoder.writeUI8(length);
			
			for (i = 0; i < length; i++)
			{
				_datas[i].encode(encoder);
			}
			
			encoder.writeUB(0, 6);
			encoder.writeUB(_maskY, 1);
			encoder.writeUB(_maskX, 1);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ZoneRecord/>");
			result.@maskY = Boolean(_maskY);
			result.@maskX = Boolean(_maskX);
			
			var length:uint = _datas.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML(_datas[i].toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Compressed alignment zone information.
		 */		
		public function get datas():Vector.<ZoneData> { return _datas; }

		/**
		 * Set if there are X alignment zones.
		 */		
		public function get maskX():uint { return _maskX; }

		/**
		 * Set if there are Y alignment zones.
		 */		
		public function get maskY():uint { return _maskY; }
	}
}