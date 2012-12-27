package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.ColorTransformRecord;
	import com.larrio.dump.model.MatrixRecord;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 26, 2012 9:37:05 AM
	 */
	public class PlaceObjectTag extends SWFTag
	{
		public static const TYPE:uint = TagType.PLACE_OBJECT;
		
		protected var _depth:uint;
		protected var _matrix:MatrixRecord;
		protected var _colorTransform:ColorTransformRecord;
		
		/**
		 * 构造函数
		 * create a [PlaceObjectTag] object
		 */
		public function PlaceObjectTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			_depth = decoder.readUI16();
			
			_matrix = new MatrixRecord();
			_matrix.decode(decoder);
			
			if (decoder.bytesAvailable)
			{
				_colorTransform = new ColorTransformRecord();
				_colorTransform.decode(decoder);
			}
			
			trace(this);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeUI16(_depth);
			
			_matrix.encode(encoder);
			
			if (_colorTransform)
			{
				_colorTransform.encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<PlaceObjectTag/>");
			result.@character = _character;
			result.appendChild(new XML(_matrix.toString()));
			if (_colorTransform)
			{
				result.appendChild(new XML(_colorTransform.toString()));
			}
			return result.toXMLString();	
		}

		/**
		 * Depth of character
		 */		
		public function get depth():uint { return _depth; }

		/**
		 * Transform matrix data
		 */		
		public function get matrix():MatrixRecord { return _matrix; }

		/**
		 * Color transform data
		 */		
		public function get colorTransform():ColorTransformRecord { return _colorTransform; }

	}
}