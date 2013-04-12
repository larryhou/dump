package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.doabc.DoABC;
	
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
		override protected function decodeTag(decoder:FileDecoder):void
		{			
			_flags = decoder.readUI32();	
			_name = decoder.readSTR();
			
			var codes:ByteArray = new ByteArray();
			decoder.readBytes(codes);
			
			decoder = new FileDecoder();
			decoder.writeBytes(codes);
			decoder.position = 0;
			
			//trace("---------------------------------");
			//trace("{DoABCTag}" + _name);
			
			_abc = new DoABC();
			_abc.decode(decoder);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUI32(_flags);
			encoder.writeSTR(_name);
			
			_abc.encode(encoder);
		}
		
		/**
		 * 格式化输出DoABCTag
		 */		
		public function toString():String
		{
			var result:String = "[DoABCTag]name: " + _name + ", flag: 0x" + _flags.toString(16).toUpperCase();
			result += "\n" + _abc.files.join("\n");
			return result;
		}

		/**
		 * DoABC解析器
		 */		
		public function get abc():DoABC { return _abc; }

		/**
		 * DoABCTag名
		 */		
		public function get name():String { return _name; }
		public function set name(value:String):void
		{
			_name = value;
		}


	}
}