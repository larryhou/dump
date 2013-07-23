package com.larrio.dump.tags.creators.audio
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.doabc.templates.audio.MP3DoABC;
	import com.larrio.dump.model.sound.SoundFormatType;
	import com.larrio.dump.model.sound.SoundRateType;
	import com.larrio.dump.files.mp3.MP3File;
	import com.larrio.dump.tags.DefineSoundTag;
	import com.larrio.dump.tags.DoABCTag;
	
	import flash.utils.ByteArray;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Jul 8, 2013 10:28:28 AM
	 */
	public class MP3TagCreator
	{
		private var _classTag:DoABCTag;
		private var _assetTag:DefineSoundTag;
		
		private var _mp3:MP3File;
		
		/**
		 * 构造函数
		 * create a [MP3TagCreator] object
		 */
		public function MP3TagCreator(bytes:ByteArray, name:String)
		{
			_classTag = new MP3DoABC(name).tag;
			
			var decoder:FileDecoder = new FileDecoder();
			decoder.writeBytes(bytes);
			decoder.position = 0;
			
			_mp3 = new MP3File(true);
			_mp3.decode(decoder);
			
			_assetTag = new DefineSoundTag();
			_assetTag.character = 0;	// 预留字段
			_assetTag.format = SoundFormatType.MP3;
			_assetTag.sampleSize = 1;	// 16位
			_assetTag.soundType = 1;	// 默认立体声
			_assetTag.sampleCount = _mp3.sampleCount;
			_assetTag.samplingRate = getSamplingRateType(_mp3.samplingRate);
			
			var data:ByteArray = new ByteArray();
			data.writeShort(0);
			data.writeBytes(bytes);
			
			_assetTag.data = data;
		}
		
		/**
		 * 根据真实采样码率计算标记位
		 */		
		private function getSamplingRateType(rate:uint):uint
		{
			if (rate >= 44100) return SoundRateType.HZ_44K;
			if (rate >= 22050) return SoundRateType.HZ_22K;
			return SoundRateType.HZ_11K;
		}

		/**
		 * 导出类
		 */		
		public function get classTag():DoABCTag { return _classTag; }

		/**
		 * 具有特征值的声音素材
		 */		
		public function get assetTag():DefineSoundTag { return _assetTag; }

		/**
		 * MP3声音文件
		 */		
		public function get mp3():MP3File { return _mp3; }
	}
}