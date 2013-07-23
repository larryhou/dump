package com.larrio.dump.files.mp3.data
{
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 1:10:21 PM
	 */
	public class BitRate
	{
		private static const _map:Dictionary = init();
		
		/**
		 * 构造函数
		 * create a [BitRate] object
		 */
		public function BitRate()
		{
			
		}
		
		private static function init():Dictionary
		{
			var key:String, list:Array;
			var map:Dictionary = new Dictionary(false);
			
			// 1
			key = createKey(1, MpegLayer.LAYER1);
			list = map[key] = [0];
			list.push(32);
			list.push(64);
			list.push(96);
			list.push(128);
			list.push(160);
			list.push(192);
			list.push(224);
			list.push(256);
			list.push(288);
			list.push(320);
			list.push(352);
			list.push(384);
			list.push(416);
			list.push(448);
			list.push(null);
			
			// 2
			key = createKey(1, MpegLayer.LAYER2);
			list = map[key] = [0];
			list.push(32);
			list.push(48);
			list.push(56);
			list.push(64);
			list.push(80);
			list.push(96);
			list.push(112);
			list.push(128);
			list.push(160);
			list.push(192);
			list.push(224);
			list.push(256);
			list.push(320);
			list.push(384);
			list.push(null);
			
			// 3
			key = createKey(1, MpegLayer.LAYER3);
			list = map[key] = [0];
			list.push(32);
			list.push(40);
			list.push(48);
			list.push(56);
			list.push(64);
			list.push(80);
			list.push(96);
			list.push(112);
			list.push(128);
			list.push(160);
			list.push(192);
			list.push(224);
			list.push(256);
			list.push(320);
			list.push(null);
			
			// 4
			key = createKey(2, MpegLayer.LAYER1);
			list = map[key] = [0];
			list.push(32);
			list.push(48);
			list.push(56);
			list.push(64);
			list.push(80);
			list.push(96);
			list.push(112);
			list.push(128);
			list.push(144);
			list.push(160);
			list.push(176);
			list.push(192);
			list.push(224);
			list.push(256);
			list.push(null);
			
			// 5
			key = createKey(2, MpegLayer.LAYER2);
			list = map[key] = [0];
			list.push(8);
			list.push(16);
			list.push(24);
			list.push(32);
			list.push(40);
			list.push(48);
			list.push(56);
			list.push(64);
			list.push(80);
			list.push(96);
			list.push(112);
			list.push(128);
			list.push(144);
			list.push(160);
			list.push(null);
			
			// 6
			map[createKey(2, MpegLayer.LAYER3)] = map[key];
			return map;
		}
		
		/**
		 * 创建键值 
		 */		
		private static function createKey(version:uint, layer:uint):String
		{
			return "V" + version + ":L" + layer; 
		}
		
		/**
		 * 根据MPEG版本和层级来获取比特位 
		 * @param bits		对应比特位
		 * @param version	MPEG版本
		 * @param layer		Layer
		 */		
		public static function getRate(bits:uint, version:uint, layer:uint):uint
		{
			if (version == MpegVersion.MPEG2_5 || version == MpegVersion.MPEG2_5) version = 2;
			if (version == MpegVersion.MPEG1) version = 1;
			
			var list:Array = _map[createKey(version, layer)] as Array;
			return list[bits] * 1000;
		}
	}
}