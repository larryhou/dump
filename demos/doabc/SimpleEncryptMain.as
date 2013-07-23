package doabc
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.encrypt.SimpleEncryptor;
	
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 24, 2013 12:21:31 AM
	 */
	public class SimpleEncryptMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [SimpleEncryptMain] object
		 */
		public function SimpleEncryptMain()
		{
			var swf:SWFile = new SWFile(loaderInfo.bytes);
			
			var encryptor:SimpleEncryptor = new SimpleEncryptor();
			encryptor.pushSWF(swf);
		}
	}
}