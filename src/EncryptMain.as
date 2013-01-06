package
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.doabc.MultinameInfo;
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
		[Embed(source="../libs/res03.swf", mimeType="application/octet-stream")]
		private var RawFile:Class;
		
		/**
		 * 构造函数
		 * create a [EncryptMain] object
		 */
		public function EncryptMain()
		{
			var bytes:ByteArray;
			
			bytes = loaderInfo.bytes;
//			bytes = new RawFile()
			var swf:SWFile = new SWFile(bytes);
			
			var encryptor:FileEncryptor = new FileEncryptor();
			encryptor.decrypting = false;
			encryptor.addFile(swf);
			
			trace(encryptor.encrypt());
			
			// 导出加密后的SWF
			bytes = swf.repack();
			//assertTrue(bytes.length == loaderInfo.bytes.length);
			//new FileReference().save(bytes, "encrypt.swf");
			
			swf = new SWFile(bytes);
			
			var tag:DoABCTag;
			for (var i:int = 0; i < swf.tags.length; i++)
			{
				if (swf.tags[i].type == DoABCTag.TYPE)
				{
					tag = swf.tags[i] as DoABCTag;
					trace("\n\n-----------------------------------------\n");
					
					//trace(tag.abc.constants.multinames.join("\n"));
					//trace(tag.abc.constants.namespaces.join("\n"));
					//trace(tag.abc.constants.strings.join("\n"));
					trace(tag.abc.files.join("\n"));
					//break;
				}
			}
			
			var callback:Function = function (data:Date):String
			{
				return data.toString();
			};
			
			var code:uint = 0;
			while (code <= 0xFF)
			{
				//trace(code + "\t" + String.fromCharCode(code));
				code++;
			}
			
			var text:TextField = new TextField();
			text.defaultTextFormat = new TextFormat("Monaco", 25, 0xFF0000);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.text = "FUCK YOU";
			addChild(text);
		}
	}
}