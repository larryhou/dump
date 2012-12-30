package com.larrio.dump.model.filters
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	import com.larrio.math.fixed;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 10:48:18 PM
	 */
	public class BlurFilter implements IFilter
	{
		private var _blurX:uint;
		private var _blurY:uint;
		
		private var _passes:uint;
		
		/**
		 * 构造函数
		 * create a [BlurFilter] object
		 */
		public function BlurFilter()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_blurX = decoder.readUI32();
			_blurY = decoder.readUI32();
			_passes = decoder.readUB(5);
			
			assertTrue(decoder.readUB(3) == 0);
			
			decoder.byteAlign();
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI32(_blurX);
			encoder.writeUI32(_blurY);
			
			encoder.writeUB(_passes, 5);
			encoder.writeUB(0, 3);
			encoder.flush();
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<BlurFilter/>");
			result.@blurX = fixed(_blurX, 16, 16);
			result.@blurY = fixed(_blurY, 16, 16);
			result.@passes = _passes;
			return result.toXMLString()
		}

		/**
		 * Horizontal blur amount:16.16 fixed-point
		 */		
		public function get blurX():uint { return _blurX; }

		/**
		 * Vertical blur amount: 16.16 fixed-point
		 */		
		public function get blurY():uint { return _blurY; }

		/**
		 * Number of blur passes
		 */		
		public function get passes():uint { return _passes; }
		
		/**
		 * 滤镜类型
		 */		
		public function get type():uint { return FilterType.BLUR_FILTER; }

	}
}