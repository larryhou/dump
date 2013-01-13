package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:30:32 PM
	 */
	public class DefineSpriteTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_SPRITE;
		
		private var _frameCount:uint;
		private var _tags:Vector.<SWFTag>;
		
		/**
		 * 构造函数
		 * create a [DefineSpriteTag] object
		 */
		public function DefineSpriteTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_dict[_character] = this;
			
			_frameCount = decoder.readUI16();
			
			_tags = new Vector.<SWFTag>();
			
			var tag:SWFTag;
			var type:uint, position:uint;
			while(decoder.bytesAvailable)
			{
				position = decoder.position;
				type = decoder.readUI16() >>> 6;
				decoder.position = position;
				
				tag = TagFactory.create(type);
				
				tag.dict = _dict;
				tag.decode(decoder);
				
				_tags.push(tag);
			}
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeUI16(_frameCount);
			
			var length:uint = _tags.length;
			for (var i:int = 0; i < length; i++)
			{
				_tags[i].encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineSpriteTag/>");
			result.@character = _character;
			result.@frameCount = _frameCount;
			
			var length:int = _tags.length;
			for (var i:int = 0; i < length; i++)
			{
				result.appendChild(new XML("" + _tags[i]));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Number of frames in sprite
		 */		
		public function get frameCount():uint { return _frameCount; }

		/**
		 * A series of tags
		 */		
		public function get tags():Vector.<SWFTag> { return _tags; }

	}
}