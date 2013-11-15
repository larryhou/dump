package com.larrio.dump.compress
{
	import flash.utils.ByteArray;
	
	/**
	 * 解压缩SWF
	 * @author larryhou
	 * @createTime Aug 22, 2013 12:40:20 PM
	 * @param source	压缩数据
	 * @param algorithm	压缩算法
	 * @param length	SWF压缩前字节长度
	 */
	public function uncompressSWF(bytes:ByteArray, algorithm:String, length:uint):void
	{
		switch (algorithm)
		{
			case CompressMethods.LZMA:uncompressLZMA(bytes, length);break;
			case CompressMethods.ZLIB:uncompressZLIB(bytes);break;
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
function uncompressLZMA(source:ByteArray, length:uint):void
{
	var position:uint = source.position;
	source.endian = Endian.LITTLE_ENDIAN;
	
	var bytes:ByteArray = new ByteArray();
	bytes.endian = Endian.LITTLE_ENDIAN;
	
	// read lzma properties
	for ( var i:uint = 0; i < 5; i++)
	{
		bytes.writeByte(source[i + 4]);
	}
	
	// write uncompressed data length
	bytes.writeUnsignedInt(length - 8);
	bytes.writeUnsignedInt(0);
	
	// write compressed data
	source.position = 9;
	source.readBytes(bytes, 13);
	
	// lzma uncompress
	bytes.position = 0;
	bytes.uncompress("lzma");
	
	// append uncompressed data
	source.position = position;
	source.writeBytes(bytes);
	bytes.clear();
	
	source.position = position;
}

function uncompressZLIB(bytes:ByteArray):void
{
	bytes.uncompress("zlib");
}