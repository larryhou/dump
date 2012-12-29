package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.model.shape.ShapeWithStyle;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:01:00 PM
	 */
	public class DefineShapeTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_SHAPE;
		
		protected var _bounds:SWFRect;
		protected var _shape:ShapeWithStyle;
		
		/**
		 * 构造函数
		 * create a [DefineShapeTag] object
		 */
		public function DefineShapeTag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_character = decoder.readUI16();
			
			_bounds = new SWFRect();
			_bounds.decode(decoder);
			
			_shape = new ShapeWithStyle(_type);
			_shape.decode(decoder);
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			_bounds.encode(encoder);
			_shape.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var name:String = getQualifiedClassName(this).split("::")[1];
			
			var result:XML = new XML("<" + name + "/>");
			result.@character = _character;
			result.appendChild(new XML(_bounds.toString()));
			result.appendChild(new XML(_shape.toString()));
			return result.toXMLString();	
		}

		/**
		 * Bounds of the shape.
		 */		
		public function get bounds():SWFRect { return _bounds; }

		/**
		 * Shape information.
		 */		
		public function get shape():ShapeWithStyle { return _shape; }

	}
}