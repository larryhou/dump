package com.larrio.dump.compress
{
	import flash.utils.ByteArray;
	
	/**
	 * 压缩SWF文件
	 * @author larryhou
	 * @createTime Aug 22, 2013 12:39:40 PM
	 * @param source	压缩数据
	 * @param algorithm	压缩算法
	 * @param length	SWF压缩前字节长度
	 */
	public function compressSWF(bytes:ByteArray, algorithm:String):void
	{
		switch (algorithm)
		{
			case CompressAlgorithms.LZMA:compressLZMA(bytes);break;
			case CompressAlgorithms.ZLIB:compressZLIB(bytes);break;
		}
	}
}
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * 不能够直接使用LZMA对压缩数据进行解压，这是因为SWF中的LZMA数据不是标准的
 * 
 * SWF头
 * 0000 5A 57 53 0F   // ZWS + Version 15
 * 0004 DF 52 00 00   // Uncompressed size: 21215
 * 
 * SWF中LZMA压缩的字节顺序
 * 0008 94 3B 00 00   // Compressed size: 15252
 * 000C 5D 00 00 00 01   // LZMA Properties
 * 0011 00 3B FF FC A6 14 16 5A ...   // LZMA Compressed Data (until EOF)
 * 
 * 标准LZMA压缩的字节顺序
 * 0000 5D 00 00 00 01   // LZMA Properties
 * 0005 D7 52 00 00 00 00 00 00   // Uncompressed size: 21207 (64 bit)
 * 000D 00 3B FF FC A6 14 16 5A ...   // LZMA Compressed Data (until EOF)
 * 
 * @param source	压缩数据
 * @param length	SWF压缩前字节长度
 */
function compressLZMA(source:ByteArray):void
{
	source.compress("lzma");
	source.position = 0;
	
	var data:ByteArray = new ByteArray();
	data.endian = Endian.LITTLE_ENDIAN;
	
	// write compressed size
	data.writeUnsignedInt(source.length - 13);
	
	// write lzma properties
	for (var i:int = 0; i < 5; i++) data.writeByte(source[i]);
	
	// write compressed data
	data.writeBytes(source, 13);
	
	source.length = 0;
	source.writeBytes(data);
	
	data.clear();
}

function compressZLIB(bytes:ByteArray):void
{
	bytes.compress("zlib");
}