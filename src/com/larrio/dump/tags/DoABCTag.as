package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * 代码指令TAG
	 * @author larryhou
	 * @createTime Dec 16, 2012 2:25:00 PM
	 */
	public class DoABCTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DO_ABC;
		
		private var _abc:DoABC;
		private var _flags:uint;
		
		private var _name:String;
		
		private var _lenR:uint;
		
		/**
		 * 构造函数
		 * create a [DoABCTag] object
		 */
		public function DoABCTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			
			super.decode(decoder);
			
			
			assertTrue(_type == DoABCTag.TYPE);
			
			decoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			_flags = decoder.readUI32();	
			_name = decoder.readSTR();
			
			var codes:ByteArray = new ByteArray();
			decoder.readBytes(codes);
			
			decoder.length = 0;
			decoder.writeBytes(codes);
			decoder.position = 0;
			
			//trace("---------------------------------");
			//trace("{DoABCTag}" + _name);
			
			_lenR = decoder.position;
			_abc = new DoABC();
			_abc.decode(decoder);
			_lenR = decoder.position - _lenR;
			
			assertTrue(_lenR == codes.length);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			var position:uint = encoder.position;
			
			writeTagHeader(encoder);
			
			if (_name == "Main")
			{
				trace(_name);
			}
			
			encoder.writeUI32(_flags);
			encoder.writeSTR(_name);
			
			var lenR:uint = encoder.position;
			_abc.encode(encoder);
			lenR = encoder.position - lenR;
			assertTrue(lenR == _lenR);
		}
		
		/**
		 * 打印DoABC解码信息
		 */		
		public function print():void
		{
			if (!_bytes) return;
			
			var decoder:FileDecoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			_abc.decode(decoder);
			
			decoder.length = 0;
		}

		/**
		 * DoABC解析器
		 */		
		public function get abc():DoABC { return _abc; }

	}
}