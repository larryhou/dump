package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.math.fixed;
	
	import flash.geom.Matrix;
	
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
			decoder.byteAlign();
			
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
			encoder.flush();
			
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
			var result:XML = new XML("<Matrix/>");
			result.@scaleX = fixed(_scaleX, 16, 16);
			result.@scaleY = fixed(_scaleY, 16, 16);
			result.@skew0 = fixed(_skew0, 16, 16);
			result.@skew1 = fixed(_skew1, 16, 16);
			result.@translateX = _translateX / 20;
			result.@translateY = _translateY / 20;
			return result.toXMLString();	
		}
		
		/**
		 * 转换成Matrix表示
		 */
		public function get matrix():Matrix
		{
			var a:Number = fixed(_scaleX, 16, 16);
			var d:Number = fixed(_scaleY, 16, 16);
			
			var b:Number = fixed(_skew1, 16, 16);
			var c:Number = fixed(_skew0, 16, 16);
			
			return new Matrix(a, b, c, d, _translateX / 20, _translateY / 20);
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