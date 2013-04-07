package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.ColorTransformRecord;
	import com.larrio.dump.model.MatrixRecord;
	
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * 控制zIndex显示对象的几何变形以及颜色变换
	 * @author larryhou
	 * @createTime Dec 26, 2012 9:37:05 AM
	 */
	public class PlaceObjectTag extends SWFTag
	{
		public static const TYPE:uint = TagType.PLACE_OBJECT;
		
		/**
		 * 显示对象zIndex 
		 */		
		public var depth:uint;
		
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
			depth = decoder.readUI16();
			
			_matrix = new MatrixRecord();
			_matrix.decode(decoder);
			
			if (decoder.bytesAvailable)
			{
				_colorTransform = new ColorTransformRecord();
				_colorTransform.decode(decoder);
			}
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			encoder.writeUI16(depth);
			
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
		 * Transform matrix data
		 */		
		public function get matrix():Matrix { return _matrix.matrix; }
		public function set matrix(value:Matrix):void
		{
			_matrix.matrix = value;
		}

		/**
		 * Color transform data
		 */		
		public function get colorTransform():ColorTransform { return _colorTransform.transform; }
		public function set colorTransform(value:ColorTransform):void
		{
			_colorTransform.transform = value;
		}
	}
}