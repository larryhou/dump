package com.larrio.dump.encrypt
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.encrypt.collectors.ClassCollector;
	import com.larrio.dump.encrypt.collectors.TypeCollector;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 23, 2013 11:38:32 PM
	 */
	public class SimpleEncryptor
	{
		private var _typeCollector:TypeCollector;
		private var _classCollector:ClassCollector;
		
		/**
		 * 构造函数
		 * create a [SimpleEncryptor] object
		 */
		public function SimpleEncryptor()
		{
			_typeCollector = new TypeCollector();
			_classCollector = new ClassCollector();
		}
		
		/**
		 * 添加SWF文件 
		 * @param swf SWFile对象
		 */	
		public function pushSWF(swf:SWFile):void
		{
			_typeCollector.collect(swf);
			_classCollector.collect(swf);
		}
		
		/**
		 * 执行加密逻辑 
		 * @param settings	加密配置
		 * @return 项目加密配置
		 */		
		public function encrypt(settings:XML = null):XML
		{
			return null;	
		}
	}
}