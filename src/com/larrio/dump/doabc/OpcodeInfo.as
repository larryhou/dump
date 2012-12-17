package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	/**
	 * 解析opcode指令
	 * @author larryhou
	 * @createTime Dec 17, 2012 1:36:53 PM
	 */
	public class OpcodeInfo implements ICodec
	{
		private static var _map:Dictionary;
		
		private var _bytes:ByteArray;
		
		private var _code:String;
		
		/**
		 * 构造函数
		 * create a [OpcodeInfo] object
		 */
		public function OpcodeInfo()
		{
			if (!_map)
			{
				_map = new Dictionary(false);
				
				var key:String;
				var config:XMLList = describeType(OpcodeType).constant;
				for each (var node:XML in config)
				{
					key = String(node.@name);
					
					_map[OpcodeType[key]] = key.replace(/_OP$/i, "").toLowerCase();
				}
			}
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_code = "";
			
			var item:String, opcode:uint;			
			while (decoder.bytesAvailable)
			{
				item = "";
				opcode = decoder.readUI8();
				
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}

		/**
		 * 已解码的opcode指令
		 */		
		public function get code():String { return _code; }
	}
}