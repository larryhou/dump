package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.SWFRect;
	import com.larrio.dump.model.morph.MorphFillStyleArray;
	import com.larrio.dump.model.morph.MorphLineStyleArray;
	import com.larrio.dump.model.shape.Shape;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 27, 2012 11:05:42 PM
	 */
	public class DefineMorphShapeTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_MORPH_SHAPE;
		
		protected var _startBounds:SWFRect;
		protected var _endBounds:SWFRect;
		
		protected var _offset:int;
		
		protected var _fillStyles:MorphFillStyleArray;
		protected var _lineStyles:MorphLineStyleArray;
		
		protected var _startEdges:Shape;
		protected var _endEdges:Shape;
		
		/**
		 * 构造函数
		 * create a [DefineMorphShapeTag] object
		 */
		public function DefineMorphShapeTag()
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
		public function toString():String
		{
			var result:XML = new XML("<DefineMorphShapeTag/>");
			result.@character = _character;
			
			result.appendChild(new XML(_startBounds.toString()));
			result.appendChild(new XML(_endBounds.toString()));
			
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
		 * Bounds of the start shape
		 */		
		public function get startBounds():SWFRect { return _startBounds; }

		/**
		 * Bounds of the end shape
		 */		
		public function get endBounds():SWFRect { return _endBounds; }

		/**
		 * Fillstyleinformationisstoredin the same manner as for a standard shape; 
		 * however, each fill consists of interleaved information based on a single style type to accommodate morphing.
		 */		
		public function get fillStyles():MorphFillStyleArray { return _fillStyles; }

		/**
		 * Line style information is stored in the same manner as for a standard shape; 
		 * however, each line consists of interleaved information based on a single style type to accommodate morphing.
		 */		
		public function get lineStyles():MorphLineStyleArray { return _lineStyles; }

		/**
		 * Contains the set of edges and the style bits that indicate style changes (for example, MoveTo, FillStyle, and LineStyle). 
		 * Number of edges must equal the number of edges in EndEdges.
		 */		
		public function get startEdges():Shape { return _startEdges; }

		/**
		 * Contains only the set of edges, with no style information.
		 * Number of edges must equal the number of edges in StartEdges.
		 */		
		public function get endEdges():Shape { return _endEdges; }

	}
}