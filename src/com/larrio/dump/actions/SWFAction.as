package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.utils.ByteArray;
	
	/**
	 * DoAction抽象类
	 * @author larryhou
	 * @createTime Dec 24, 2012 10:06:57 PM
	 */
	public class SWFAction implements ICodec
	{
		protected var _type:uint;
		protected var _length:uint;
		
		protected var _bytes:ByteArray;
		
		/**
		 * 构造函数
		 * create a [SWFAction] object
		 */
		public function SWFAction()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_type = decoder.readUI8();
			if (_type >= 0x80)
			{
				_bytes = new ByteArray();
				_length = decoder.readUI16();
				decoder.readBytes(_bytes, 0, _length);
				
				decoder = new FileDecoder();
				decoder.writeBytes(_bytes);
				decoder.position = 0;
				
				decodeAction(decoder);
			}
			
			const NAME:String = "TYPE";
			if (NAME in Object(this).constructor)
			{
				assertTrue(_type == Object(this).constructor);
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUI8(_type);
			if (_type >= 0x80)
			{
				encoder.writeUI16(_length);
				encodeAction(encoder);
			}
		}
		
		// 编码DoAction数据
		protected function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeBytes(_bytes);
		}
		
		// 解码DoAction数据
		protected function decodeAction(decoder:FileDecoder):void
		{
			
		}

		/**
		 * 类型
		 */		
		public function get type():uint { return _type; }

		/**
		 * 数据长度
		 */		
		public function get length():uint { return _length; }

		/**
		 * length对应的字节数组
		 */		
		public function get bytes():ByteArray { return _bytes; }


	}
}