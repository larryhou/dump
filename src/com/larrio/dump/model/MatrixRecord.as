package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.math.fixed;
	import com.larrio.math.unfixed;
	
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
			result.@scaleX = this.scaleX;
			result.@scaleY = this.scaleY;
			result.@skew0 = this.skew0;
			result.@skew1 = this.skew1;
			result.@translateX = this.translateX;
			result.@translateY = this.translateY;
			return result.toXMLString();	
		}
		
		/**
		 * 转换成Matrix表示
		 */
		public function get matrix():Matrix
		{
			var a:Number = this.scaleX;
			var d:Number = this.scaleY;
			
			var b:Number = this.skew1;
			var c:Number = this.skew0;
			
			return new Matrix(a, b, c, d, this.translateX, this.translateY);
		}
		
		/**
		 * 把原生Matrix转换成MatrixRecord 
		 */		
		public function set matrix(value:Matrix):void
		{
			value ||= new Matrix();
			
			this.scaleX = value.a;
			this.scaleY = value.d;
			
			this.skew1 = value.b;
			this.skew0 = value.c;
			
			this.translateX = value.tx;
			this.translateY = value.ty;
			
			if (_scale) _sbits = 0x1F;
			if (_rotate) _rbits = 0x1F;
		}

		/**
		 * 横向缩放：16.16 fixed-point
		 */		
		public function get scaleX():Number { return fixed(_scaleX, 16, 16); }
		public function set scaleX(value:Number):void
		{
			_scale = true;
			_scaleX = unfixed(value, 16, 16);
		}

		/**
		 * 竖向缩放：16.16 fixed-point
		 */		
		public function get scaleY():Number { return fixed(_scaleY, 16, 16); }
		public function set scaleY(value:Number):void
		{
			_scale = true;
			_scaleY = unfixed(value, 16, 16);
		}

		/**
		 * first rotate and skew：16.16 fixed-point
		 */		
		public function get skew0():Number { return fixed(_skew0, 16, 16); }
		public function set skew0(value:Number):void
		{
			_rotate = true;
			_skew0 = unfixed(value, 16, 16);
		}

		/**
		 * second rotate and skew：16.16 fixed-point
		 */		
		public function get skew1():Number { return fixed(_skew1, 16, 16); }
		public function set skew1(value:Number):void
		{
			_rotate = true;
			_skew1 = unfixed(value, 16, 16);
		}

		/**
		 * 横向平移：twips
		 */		
		public function get translateX():Number { return _translateX / 20; }
		public function set translateX(value:Number):void
		{
			_translateX = value * 20 >> 0;
		}

		/**
		 * 竖向平移：twips
		 */		
		public function get translateY():Number { return _translateY / 20; }
		public function set translateY(value:Number):void
		{
			_translateY = value * 20 >> 0;
		}
		
	}
}