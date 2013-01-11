package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.model.morph.MorphFillStyleArray;
	import com.larrio.dump.model.morph.MorphLineStyleArray;
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:06:32 PM
	 */
	public class DefineMorphShape2Tag extends DefineMorphShapeTag
	{
		public static const TYPE:uint = TagType.DEFINE_MORPH_SHAPE2;
		
		private var _startEdgeBounds:SWFRect;
		private var _endEdgeBounds:SWFRect;
		
		private var _useNonScalingStrokes:uint;
		private var _useScalingStrokes:uint;
		
		/**
		 * 构造函数
		 * create a [DefineMorphShape2Tag] object
		 */
		public function DefineMorphShape2Tag()
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
			
			_startBounds = new SWFRect();
			_startBounds.decode(decoder);
			
			_endBounds = new SWFRect();
			_endBounds.decode(decoder);
			
			_startEdgeBounds = new SWFRect();
			_startEdgeBounds.decode(decoder);
			
			_endEdgeBounds = new SWFRect();
			_endEdgeBounds.decode(decoder);
			
			assertTrue(decoder.readUB(6) == 0);
			
			_useNonScalingStrokes = decoder.readUB(1);
			_useScalingStrokes = decoder.readUB(1);
			
			_offset = decoder.readS32();
			
			_fillStyles = new MorphFillStyleArray();
			_fillStyles.decode(decoder);
			
			_lineStyles = new MorphLineStyleArray(_type);
			_lineStyles.decode(decoder);
			
			_startEdges = new Shape(TagType.DEFINE_SHAPE3);
			_startEdges.decode(decoder);
			
			if (_offset != 0)
			{
				_endEdges = new Shape(TagType.DEFINE_SHAPE3);
				_endEdges.decode(decoder);
			}
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI16(_character);
			
			_startBounds.encode(encoder);
			_endBounds.encode(encoder);
			
			_startEdgeBounds.encode(encoder);
			_endEdgeBounds.encode(encoder);
			
			encoder.writeUB(0, 6);
			encoder.writeUB(_useNonScalingStrokes, 1);
			encoder.writeUB(_useScalingStrokes, 1);
			
			encoder.writeS32(_offset);
			
			_fillStyles.encode(encoder);
			_lineStyles.encode(encoder);
			
			_startEdges.encode(encoder);
			if (_offset != 0)
			{
				_endEdges.encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<DefineMorphShape2Tag/>");
			result.@character = _character;
			
			result.@useNonScalingStrokes = Boolean(_useNonScalingStrokes);
			result.@useScalingStrokes = Boolean(_useScalingStrokes);
			
			result.appendChild(new XML(_startBounds.toString()));
			result.appendChild(new XML(_endBounds.toString()));
			
			result.appendChild(new XML(_startEdgeBounds.toString()));
			result.appendChild(new XML(_endEdgeBounds.toString()));
			
			result.appendChild(new XML(_fillStyles.toString()));
			result.appendChild(new XML(_lineStyles.toString()));
			
			result.appendChild(new XML(_startEdges.toString()));
			if (_offset != 0)
			{
				result.appendChild(new XML(_endEdges.toString()));
			}
			
			return result.toXMLString();	
		}

		/**
		 * Bounds of the start shape, excluding strokes
		 */		
		public function get startEdgeBounds():SWFRect { return _startEdgeBounds; }

		/**
		 * Bounds of the end shape, excluding strokes
		 */		
		public function get endEdgeBounds():SWFRect { return _endEdgeBounds; }

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