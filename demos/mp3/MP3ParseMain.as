package mp3
{
	import com.larrio.dump.model.sound.mp3.MP3File;
	
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 21, 2013 4:08:39 PM
	 */
	public class MP3ParseMain extends Sprite
	{
		[Embed(source="../libs/sleep.mp3", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [MP3ParseMain] object
		 */
		public function MP3ParseMain()
		{
			var file:MP3File = new MP3File(true);
			file.decode(new FileByteArray());
			//trace(file);
			
		}
	}
}