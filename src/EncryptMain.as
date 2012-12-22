package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.encrypt.FileEncryptor;
	
	import flash.display.Sprite;
	
	/**
	 * 加密测试入口
	 * @author larryhou
	 * @createTime Dec 22, 2012 8:26:45 PM
	 */
	public class EncryptMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [EncryptMain] object
		 */
		public function EncryptMain()
		{
			var file:SWFile = new SWFile(loaderInfo.bytes);
			
			var encryptor:FileEncryptor = new FileEncryptor();
			encryptor.addFile(file);
			encryptor.encrypt();
		}
	}
}