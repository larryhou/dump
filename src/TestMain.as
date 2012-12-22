package
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 3:05:12 AM
	 */
	public class TestMain extends Sprite
	{
		/**
		 * 构造函数
		 * create a [TestMain] object
		 */
		public function TestMain()
		{
			var src:FileEncoder = new FileEncoder();
			var dst:FileDecoder = new FileDecoder();
			
			var str:String;
			var length:uint, i:int;
			
			var loop:uint = 0;
			while (loop < 1000)
			{
				length = Math.random() * 100 >> 0;
				str = createSTR(length, false);
				
				src.writeEU30(length);
				src.writeUTFBytes(str);
				loop++;
				
				trace(loop);
			}
			
			dst.writeBytes(src);
			dst.position = 0;
			
			var index:int = 0;
			var list:Vector.<String> = new Vector.<String>(loop, true);
			
			while (dst.bytesAvailable)
			{
				length = dst.readEU30();
				list[index++] = dst.readUTFBytes(length);
			}
			
			length = list.length;
			for (i = 0; i < length; i++)
			{
				list[i] = createSTR(list[i].length);
			}
			
			src.length = 0;
			for (i = 0; i < length; i++)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeUTFBytes(list[i]);
				
				src.writeEU30(bytes.length);
				src.writeBytes(bytes);
			}
			
			assertTrue(src.length == dst.length);
		}
		
		// 获取加密字符串
		private function createSTR(length:uint, encrypt:Boolean = true):String
		{
			var result:String = "";
			
			var code:int;
			while (result.length < length)
			{
				if (encrypt)
				{
					code = 33 + Math.random() * (126 - 33) >> 0;
				}
				else
				{
					code = 97 + Math.random() * (122 - 97) >> 0;
				}
				result += String.fromCharCode(code);
				
			}
			
			assertTrue(result.length == length);
			
			return result;
		}

	}
}