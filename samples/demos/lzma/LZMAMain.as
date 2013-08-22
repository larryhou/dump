package demos.lzma
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.compress.CompressAlgorithms;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.FileReference;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	[SWF(width="1024", height="768")]
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Aug 22, 2013 11:18:14 AM
	 */
	public class LZMAMain extends Sprite
	{
		[Embed(source="../libs/lzma.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [LZMAMain] object
		 */
		public function LZMAMain()
		{
			var data:ByteArray = new FileByteArray();
			
			trace(Capabilities.version);
			var swf:SWFile = new SWFile(new FileByteArray());
			trace(swf.header);
			
			swf = new SWFile(swf.repack());
			swf.header.compressAlgorithm = CompressAlgorithms.ZLIB;
			trace(swf.header);
			
			var loader:Loader = new Loader();
			loader.loadBytes(swf.repack());
			addChild(loader);
		}
		
		private function printBytes(bytes:ByteArray, length:uint = 1):String
		{
			const HASH:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
			
			var byte:uint;
			var results:Array = [];
			
			var count:int = 0;
			while (count < length)
			{
				byte = bytes.readUnsignedByte();
				results.push(HASH[byte >>> 4] + HASH[byte & 0xF]);
				count++;
			}
			
			return results.join(" ");
		}
	}
}