package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFRect;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 4:57:13 PM
	 */
	public class DefineScalingGridTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_SCALING_GRID;
		
		private var _splitter:SWFRect;
		
		/**
		 * 构造函数
		 * create a [DefineScalingGridTag] object
		 */
		public function DefineScalingGridTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_dict[_character] = this;
			
			_splitter = new SWFRect();
			_splitter.decode(decoder);
			
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			_splitter.encode(encoder);
			
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineScalingGridTag/>");
			result.@character = _character;
			result.appendChild(new XML(_splitter.toString()));
			return result.toXMLString();
		}

		/**
		 * 九宫格
		 */		
		public function get splitter():SWFRect { return _splitter; }

		
	}
}