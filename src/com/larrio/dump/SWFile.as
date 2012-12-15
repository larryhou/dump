package com.larrio.dump
{
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	
	/**
	 * SWF文件
	 * @author larryhou
	 * @createTime Dec 15, 2012 6:18:33 PM
	 */
	public class SWFile
	{
		// 编解码工具
		private var _codec:Codec;
		
		/**
		 * 构造函数
		 * create a [SWFile] object
		 */
		public function SWFile()
		{
			// 数据化编解码器
			_codec = new Codec();
			_codec.encoder = new FileEncoder();
			_codec.decoder = new FileDecoder();
		}
	}
}