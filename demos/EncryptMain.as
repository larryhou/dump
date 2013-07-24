package 
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.encrypt.FileEncryptor;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.display.Sprite;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	/**
	 * 加密测试入口
	 * @author larryhou
	 * @createTime Dec 22, 2012 8:26:45 PM
	 */
	public class EncryptMain extends Sprite
	{
		[Embed(source="../libs/res04.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [EncryptMain] object
		 */
		public function EncryptMain()
		{
			var bytes:ByteArray;
			
			bytes = loaderInfo.bytes;
			bytes = new FileByteArray()
			var swf:SWFile = new SWFile(bytes);
			
			var encryptor:FileEncryptor = new FileEncryptor();
			encryptor.pushSWF(swf);
			
			trace(encryptor.encrypt());
			trace(encryptor.log);
			
			// 导出加密后的SWF
			bytes = swf.repack();
			new FileReference().save(bytes, "encrypt.swf");
			
			swf = new SWFile(bytes);
			
			var tag:DoABCTag;
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				break;
				if (swf.tags[i].type == DoABCTag.TYPE)
				{
					tag = swf.tags[i] as DoABCTag;
					trace("\n\n-----------------------------------------\n");
					
					//trace(tag.abc.constants.strings.join("\n"));
					trace(tag.abc.files.join("\n"));
				}
			}
			
			var text:TextField = new TextField();
			text.defaultTextFormat = new TextFormat("Monaco", 25, 0xFF0000);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.text = "EncryptTest";
			addChild(text);
		}
	}
}