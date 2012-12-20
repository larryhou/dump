package com.larrio.dump.doabc
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * DoABC之代码信息
	 * @author larryhou
	 * @createTime Dec 16, 2012 3:43:37 PM
	 */
	public class ClassInfo extends ScriptInfo
	{
		private var _instance:InstanceInfo;
		
		/**
		 * 构造函数
		 * create a [ClassInfo] object
		 */
		public function ClassInfo(abc:DoABC)
		{
			super(abc);
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
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
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:String = "class:";
			result += _abc.constants.multinames[_instance.name];
			
			var indent:String = "      ";
			if (_traits.length) result += "\n" + indent + "[Trait]" + _traits.join("\n" + indent + "[Trait]");
			return result;
		}
		
		/**
		 * class对应instance
		 */		
		public function get instance():InstanceInfo { return _instance; }
		public function set instance(value:InstanceInfo):void
		{
			_instance = value;
		}
	}
}