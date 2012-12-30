package com.larrio.dump.model.fonts
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 30, 2012 5:34:13 PM
	 */
	public class KerningRecord implements ICodec
	{
		private var _wideCodes:uint;
		
		private var _code1:uint;
		private var _code2:uint;
		
		private var _adjustment:int;
		
		/**
		 * 构造函数
		 * create a [KerningRecord] object
		 */
		public function KerningRecord(wideCodes:uint)
		{
			_wideCodes = wideCodes;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			if (_wideCodes)
			{
				_code1 = decoder.readUI16();
				_code2 = decoder.readUI16();
			}
			else
			{
				_code1 = decoder.readUI8();
				_code2 = decoder.readUI8();
			}
			
			_adjustment = decoder.readS16();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			if (_wideCodes)
			{
				encoder.writeUI16(_code1);
				encoder.writeUI16(_code2);
			}
			else
			{
				encoder.writeUI8(_code1);
				encoder.writeUI8(_code2);
			}
			
			encoder.writeS16(_adjustment);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<KerningRecord/>");
			result.@code1 = _code1;
			result.@code2 = _code2;
			result.@adjusetment = _adjustment;
			
			return result.toXMLString();	
		}
		
		/**
		 * Character code of the left character.
		 */		
		public function get code1():uint { return _code1; }

		/**
		 * Character code of the right character.
		 */		
		public function get code2():uint { return _code2; }

		/**
		 * Adjustment relative to left character’s advance value.
		 */		
		public function get adjustment():int { return _adjustment; }

	}
}