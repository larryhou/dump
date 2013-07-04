package com.larrio.dump.model.sound.mp3
{
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 1:36:32 PM
	 */
	public class SamplingRate
	{		
		private static const _map:Dictionary = init();
		
		/**
		 * 构造函数
		 * create a [SamplingRate] object
		 */
		public function SamplingRate()
		{
			
		}
		
		private static function init():Dictionary
		{
			var list:Array;
			var map:Dictionary = new Dictionary();
			
			list = map[MpegVersion.MPEG1] = [];
			list.push(44100);
			list.push(48000);
			list.push(32000);
			list.push(null);
			
			list = map[MpegVersion.MPEG2] = [];
			list.push(22050);
			list.push(24000);
			list.push(16000);
			list.push(null);
			
			list = map[MpegVersion.MPEG2_5] = [];
			list.push(11025);
			list.push(12000);
			list.push(8000);
			list.push(null);
			
			return map;
		}
		
		/**
		 * 获取实际采样率 
		 * @param bits		采样率索引
		 * @param version	MPEG版本
		 */		
		public static function getRate(bits:uint, version:uint):uint
		{
			if (bits > 3 || bits == 1 || version <= 0 || version > 2) return 0;
			var list:Array = _map[version];
			return list[bits];
		}
	}
}