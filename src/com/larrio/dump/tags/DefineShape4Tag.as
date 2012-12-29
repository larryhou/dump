package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.model.shape.ShapeWithStyle;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:09:36 PM
	 */
	public class DefineShape4Tag extends DefineShape3Tag
	{
		public static const TYPE:uint = TagType.DEFINE_SHAPE4;
		
		private var _edge:SWFRect;
		
		private var _useFillWindingRule:uint;
		private var _useNonScalingStrokes:uint;
		private var _useScalingStrokes:uint;
		
		/**
		 * 构造函数
		 * create a [DefineShape4Tag] object
		 */
		public function DefineShape4Tag()
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
			
			_edge = new SWFRect();
			_edge.decode(decoder);
			
			assertTrue(decoder.readUB(5) == 0);
			
			_useFillWindingRule = decoder.readUB(1);
			_useNonScalingStrokes = decoder.readUB(1);
			_useScalingStrokes = decoder.readUB(1);
			
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
			_edge.encode(encoder);
			
			encoder.writeUB(0, 5);
			
			encoder.writeUB(_useFillWindingRule, 1);
			encoder.writeUB(_useNonScalingStrokes, 1);
			encoder.writeUB(_useScalingStrokes, 1);
			
			_shape.encode(encoder);
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<DefineShape4Tag/>");
			result.@character = _character;
			result.@useFillWindingRule = Boolean(_useFillWindingRule);
			result.@useNonScalingStrokes = Boolean(_useNonScalingStrokes);
			result.@useScalingStrokes = Boolean(_useScalingStrokes);
			
			var item:XML;
			item = new XML("<ShapeBounds/>");
			item.appendChild(new XML(_bounds.toString()));
			result.appendChild(item);
			
			item = new XML("<EdgeBounds/>");
			item.appendChild(new XML(_edge.toString()));
			result.appendChild(item);
			
			result.appendChild(new XML(_shape.toString()));
			return result.toXMLString();	
		}

		/**
		 * Bounds of the shape, excluding strokes.
		 */		
		public function get edge():SWFRect { return _edge; }

		/**
		 * If 1, use fill winding rule. Minimum file format version is SWF 10
		 */		
		public function get useFillWindingRule():uint { return _useFillWindingRule; }

		/**
		 * If 1, the shape contains at least one non-scaling stroke.
		 */		
		public function get useNonScalingStrokes():uint { return _useNonScalingStrokes; }

		/**
		 * If 1, the shape contains at least one scaling stroke.
		 */		
		public function get useScalingStrokes():uint { return _useScalingStrokes; }
		
	}
}