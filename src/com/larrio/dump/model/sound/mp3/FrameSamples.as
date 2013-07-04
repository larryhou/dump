package com.larrio.dump.model.sound.mp3
{
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 4, 2013 5:35:34 PM
	 */
	public class FrameSamples
	{
		private static const _map:Dictionary = init();
		
		/**
		 * 构造函数
		 * create a [FrameSamples] object
		 */
		public function FrameSamples()
		{
			
		}
		
		private static function init():Dictionary
		{
			var list:Array;
			var map:Dictionary = new Dictionary();
			list = map[MpegVersion.MPEG1] = [];
			list[MpegLayer.LAYER1] = 384;
			list[MpegLayer.LAYER2] = 1152;
			list[MpegLayer.LAYER3] = 1152;
			
			list = map[MpegVersion.MPEG2] = [];
			list[MpegLayer.LAYER1] = 384;
			list[MpegLayer.LAYER2] = 1152;
			list[MpegLayer.LAYER3] = 576;

			list = map[MpegVersion.MPEG2_5] = [];
			list[MpegLayer.LAYER1] = 384;
			list[MpegLayer.LAYER2] = 1152;
			list[MpegLayer.LAYER3] = 576;
			
			return map;
		}
		
		public static function getFrameCount(version:uint, layer:uint):uint
		{
			return _map[version][layer];
		}
	}
}