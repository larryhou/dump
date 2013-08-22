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
function compressLZMA(bytes:ByteArray):void
{
	var length:uint = bytes.length;
	bytes.compress("lzma");
	
	var properties:ByteArray = new ByteArray();
	
	bytes.position = 0;
	bytes.readBytes(properties, 0, 5);
	
	var data:ByteArray = new ByteArray();
	data.endian = Endian.LITTLE_ENDIAN;
	
	bytes.position = 13;
	
	// write compressed size
	data.writeUnsignedInt(bytes.length - bytes.position);
	trace(bytes.length - bytes.position, length);
	
	// write lzma properties
	data.writeBytes(properties);
	
	// write compressed data
	bytes.readBytes(data, data.position);
	
	bytes.length = 0;
	bytes.writeBytes(data);
	
	data.clear();
}

function compressZLIB(bytes:ByteArray):void
{
	bytes.compress("zlib");
}