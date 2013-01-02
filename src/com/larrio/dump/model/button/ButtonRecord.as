package com.larrio.dump.model.button
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.model.ColorTransformRecord;
	import com.larrio.dump.model.FilterList;
	import com.larrio.dump.model.MatrixRecord;
	import com.larrio.dump.tags.TagType;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jan 2, 2013 4:53:29 PM
	 */
	public class ButtonRecord implements ICodec
	{
		private var _hasBlendMode:uint;
		private var _hasFilter:uint;
		
		private var _hitTest:uint;
		private var _down:uint;
		private var _over:uint;
		private var _up:uint;
		
		private var _character:uint;
		
		private var _depth:uint;
		private var _matrix:MatrixRecord;
		private var _colorTransform:ColorTransformRecord;
		private var _filter:FilterList;
		private var _blendMode:uint;
		
		private var _button:uint;
		
		/**
		 * 构造函数
		 * create a [ButtonRecord] object
		 */
		public function ButtonRecord(button:uint)
		{
			_button = button;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			decoder.byteAlign();
			
			decoder.readUB(2);
			
			_hasBlendMode = decoder.readUB(1);
			_hasFilter = decoder.readUB(1);
			
			_hitTest = decoder.readUB(1);
			_down = decoder.readUB(1);
			_over = decoder.readUB(1);
			_up = decoder.readUB(1);
			
			_character = decoder.readUI16();
			_depth = decoder.readUI16();
			
			_matrix = new MatrixRecord();
			_matrix.decode(decoder);
			
			if (_button == TagType.DEFINE_BUTTON2)
			{
				_colorTransform = new ColorTransformRecord(true);
				_colorTransform.decode(decoder);
				
				if (_hasFilter)
				{
					_filter = new FilterList();
					_filter.decode(decoder);
				}
				
				if (_hasBlendMode)
				{
					_blendMode = decoder.readUI8();
				}
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.flush();
			
			encoder.writeUB(0, 2);
			
			encoder.writeUB(_hasBlendMode, 1);
			encoder.writeUB(_hasFilter, 1);
			
			encoder.writeUB(_hitTest, 1);
			encoder.writeUB(_down, 1);
			encoder.writeUB(_over, 1);
			encoder.writeUB(_up, 1);
			
			encoder.writeUI16(_character);
			encoder.writeUI16(_depth);
			
			_matrix.encode(encoder);
			
			if (_button == TagType.DEFINE_BUTTON2)
			{
				_colorTransform.encode(encoder);
				
				if (_hasFilter)
				{
					_filter.encode(encoder);
				}
				
				if (_hasBlendMode)
				{
					encoder.writeUI8(_blendMode);
				}
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<ButtonRecord/>");
			result.@character = _character;
			result.@depth = _depth;
			
			result.@hitTest = Boolean(_hitTest);
			result.@down = Boolean(_down);
			result.@over = Boolean(_over);
			result.@up = Boolean(_up);
			
			result.appendChild(new XML(_matrix.toString()));
			if (_button == TagType.DEFINE_BUTTON2)
			{
				result.appendChild(new XML(_colorTransform.toString()));
				
				if (_hasFilter)
				{
					result.appendChild(new XML(_filter.toString()));
				}
				
				if (_hasBlendMode)
				{
					result.@blendMode = _blendMode;
				}
			}
			
			return result.toXMLString();	
		}

		/**
		 * Present in hit test state
		 */		
		public function get hitTest():uint { return _hitTest; }

		/**
		 * Present in down state
		 */		
		public function get down():uint { return _down; }

		/**
		 * Present in over state
		 */		
		public function get over():uint { return _over; }

		/**
		 * Present in up state
		 */		
		public function get up():uint { return _up; }

		/**
		 * Depth at which to place character
		 */		
		public function get depth():uint { return _depth; }

		/**
		 * Transformation matrix for character placement
		 */		
		public function get matrix():MatrixRecord { return _matrix; }

		/**
		 * Character color transform
		 */		
		public function get colorTransform():ColorTransformRecord { return _colorTransform; }

		/**
		 * List of filters on this button
		 */		
		public function get filter():FilterList { return _filter; }

		/**
		 * 0 or 1 = normal 
		 * 2 = layer
		 * 3 = multiply
		 * 4 = screen
		 * 5 = lighten
		 * 6 = darken
		 * 7 = difference
		 * 8 = add
		 * 9 = subtract
		 * 10 = invert
		 * 11 = alpha
		 * 12 = erase
		 * 13 = overlay
		 * 14 = hardlight
		 * Values 15 to 255 are reserved.
		 */		
		public function get blendMode():uint { return _blendMode; }

	}
}