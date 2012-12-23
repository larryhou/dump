package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 1:25:06 AM
	 */
	public class MatrixRecord implements ICodec
	{
		private var _scale:Boolean;
		private var _sbits:uint;
		private var _scaleX:uint;
		private var _scaleY:uint;
		
		private var _rotate:Boolean;
		private var _rbits:uint;
		private var _skew0:uint;
		private var _skew1:uint;
		
		private var _tbits:uint;
		private var _translateX:int;
		private var _translateY:int;
		
		/**
		 * 构造函数
		 * create a [MatrixRecord] object
		 */
		public function MatrixRecord()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_scale = Boolean(decoder.readUB(1));
			if (_scale)
			{
				_sbits = decoder.readUB(5);
				_scaleX = decoder.readUB(_sbits);
				_scaleY = decoder.readUB(_sbits);
			}
			
			_rotate = Boolean(decoder.readUB(1));
			if (_rotate)
			{
				_rbits = decoder.readUB(5);
				_skew0 = decoder.readUB(_rbits);
				_skew1 = decoder.readUB(_rbits);
			}
			
			_tbits = decoder.readUB(5);
			_translateX = decoder.readSB(_tbits);
			_translateY = decoder.readSB(_tbits);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(int(_scale), 1);
			if (_scale)
			{
				encoder.writeUB(_sbits, 5);
				encoder.writeUB(_scaleX, _sbits);
				encoder.writeUB(_scaleY, _sbits);
			}
			
			encoder.writeUB(int(_rotate), 1);
			if (_rotate)
			{
				encoder.writeUB(_rbits, 5);
				encoder.writeUB(_skew0, _rbits);
				encoder.writeUB(_skew1, _rbits);
			}
			
			encoder.writeUB(_tbits, 5);
			encoder.writeSB(_translateX, _tbits);
			encoder.writeSB(_translateY, _tbits);
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			return "";	
		}

		/**
		 * 横向缩放：16.16 fixed-point
		 */		
		public function get scaleX():uint { return _scaleX; }

		/**
		 * 竖向缩放：16.16 fixed-point
		 */		
		public function get scaleY():uint { return _scaleY; }

		/**
		 * first rotate and skew：16.16 fixed-point
		 */		
		public function get skew0():uint { return _skew0; }

		/**
		 * second rotate and skew：16.16 fixed-point
		 */		
		public function get skew1():uint { return _skew1; }

		/**
		 * 横向平移：twips
		 */		
		public function get translateX():int { return _translateX; }

		/**
		 * 竖向平移：twips
		 */		
		public function get translateY():int { return _translateY; }
		
	}
}