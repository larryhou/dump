package com.larrio.dump.files.mp3
{
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 6:52:34 PM
	 */
	public class UnknownByte
	{
		public var offset:uint;
		public var byte:uint;
		
		/**
		 * 构造函数
		 * create a [UnknownByte] object
		 */
		public function UnknownByte(offset:uint, byte:uint)
		{
			this.offset = offset; this.byte = byte & 0xFF;
		}
	}
}