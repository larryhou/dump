package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:20:40 PM
	 */
	public class CSMTextSettingsTag extends SWFTag
	{
		public static const TYPE:uint = TagType.CSM_TEXT_SETTINGS;
		
		private var _text:uint;
		private var _useFlashType:uint;
		private var _gridFit:uint;
		private var _thickness:Number;
		private var _sharpness:Number;
		
		/**
		 * 构造函数
		 * create a [CSMTextSettingsTag] object
		 */
		public function CSMTextSettingsTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_text = decoder.readUI16();
			
			_useFlashType = decoder.readUB(2);
			_gridFit = decoder.readUB(3);
			
			assertTrue(decoder.readUB(3) == 0);
			decoder.byteAlign();
			
			_thickness = decoder.readFloat();
			_sharpness = decoder.readFloat();
			
			assertTrue(decoder.readUI8() == 0);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_text);
			
			encoder.writeUB(_useFlashType, 2);
			encoder.writeUB(_gridFit, 3);
			encoder.writeUB(0, 3);
			encoder.flush();
			
			encoder.writeFloat(_thickness);
			encoder.writeFloat(_sharpness);
			encoder.writeUI8(0);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<CSMTextSettingsTag/>");
			result.@text = _text;
			result.@thickness = _thickness;
			result.@sharpness = _sharpness;
			result.@useFlashType = _useFlashType;
			result.@gridFit = _gridFit;
			return result.toXMLString();	
		}

		/**
		 * ID for the DefineText, DefineText2, or DefineEditText to which this tag applies.
		 */		
		public function get text():uint { return _text; }

		/**
		 * 0 = use normal renderer. 
		 * 1 = use advanced text rendering engine.
		 */		
		public function get useFlashType():uint { return _useFlashType; }

		/**
		 * 0 = Do not use grid fitting. 
		 * AlignmentZones and LCD sub-pixel information will not be used.
		 * 
		 * 1 = Pixel grid fit. 
		 * Only supported for left-aligned dynamic text. This setting provides the ultimate in advanced anti-aliased text readability, with crisp letters aligned to pixels.
		 * 
		 * 2 = Sub-pixel grid fit. 
		 * Align letters to the 1/3 pixel used by LCD monitors. Can also improve quality for CRT output.
		 */		
		public function get gridFit():uint { return _gridFit; }

		/**
		 * The thickness attribute for the associated text field. 
		 * Set to 0.0 to use the default (anti-aliasing table) value.
		 */		
		public function get thickness():Number { return _thickness; }

		/**
		 * The sharpness attribute for the associated text field. 
		 * Set to 0.0 to use the default (anti-aliasing table) value.
		 */		
		public function get sharpness():Number { return _sharpness; }

	}
}