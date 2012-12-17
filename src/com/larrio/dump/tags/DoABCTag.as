package com.larrio.dump.tags
{
	import com.larrio.dump.doabc.DoABC;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	import com.larrio.utils.assertTrue;
	
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
			
			_bytes.length = 0;
			decoder.readBytes(_bytes);
			
			decoder.length = 0;
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			trace("---------------------------------");
			trace("{DoABCTag}" + _name);
			
			_abc = new DoABC();
			_abc.decode(decoder);
			
			// 垃圾回收
			decoder.length = 0;
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			super.encode(encoder);
			
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