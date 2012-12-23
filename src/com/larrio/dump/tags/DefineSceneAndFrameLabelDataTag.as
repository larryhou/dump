package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 23, 2012 11:43:37 PM
	 */
	public class DefineSceneAndFrameLabelDataTag extends SWFTag
	{
		public static const TYPE:uint = TagType.DEFINE_SCENE_AND_FRAME_LABEL_DATA;
		
		private var _offsets:Vector.<uint>;
		private var _scenes:Vector.<String>;
		
		private var _nums:Vector.<uint>;
		private var _labels:Vector.<String>;
		
		/**
		 * 构造函数
		 * create a [DefineSceneAndFrameLabelDataTag] object
		 */
		public function DefineSceneAndFrameLabelDataTag()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		override public function decode(decoder:FileDecoder):void
		{
			super.decode(decoder);
			
			assertTrue(_type == DefineSceneAndFrameLabelDataTag.TYPE);
			
			decoder = new FileDecoder();
			decoder.writeBytes(_bytes);
			decoder.position = 0;
			
			var length:uint, i:int;
			
			length = decoder.readEU32();
			
			_offsets = new Vector.<uint>(length, true);
			_scenes = new Vector.<String>(length, true);
			for (i = 0; i < length; i++)
			{
				_offsets[i] = decoder.readEU32();
				_scenes[i] = decoder.readSTR();
			}
			
			length = decoder.readEU32();
			
			_nums = new Vector.<uint>(length, true);
			_labels = new Vector.<String>(length, true);
			
			for (i = 0; i < length; i++)
			{
				_nums[i] = decoder.readEU32();
				_labels[i] = decoder.readSTR();
			}
			
			trace(this);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		override public function encode(encoder:FileEncoder):void
		{
			writeTagHeader(encoder);
			
			var length:uint, i:int;
			
			length = _offsets.length;
			encoder.writeEU32(length);
			for (i = 0; i < length; i++)
			{
				encoder.writeEU32(_offsets[i]);
				encoder.writeSTR(_scenes[i]);
			}
			
			length = _nums.length;
			encoder.writeEU32(length);
			for (i = 0; i < length; i++)
			{
				encoder.writeEU32(_nums[i]);
				encoder.writeSTR(_labels[i]);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		public function toString():String
		{
			var result:XML = new XML("<DefineSceneAndFrameLabelDataTag/>");
			
			var item:XML;
			var length:uint, i:int;
			
			length = _offsets.length;
			for (i = 0; i < length; i++)
			{
				item = new XML("<scene/>");
				item.@offset = _offsets[i];
				item.@name = _scenes[i];
				result.appendChild(item);
			}
			
			length = _nums.length;
			for (i = 0; i < length; i++)
			{
				item = new XML("<framelabel/>");
				item.@num = _nums[i];
				item.@name = _labels[i];
				result.appendChild(item);
			}

			return result.toXMLString();	
		}

		/**
		 * frame offset for scene
		 */		
		public function get offsets():Vector.<uint> { return _offsets; }

		/**
		 * scene name
		 */		
		public function get scenes():Vector.<String> { return _scenes; }

		/**
		 * frame number
		 */		
		public function get nums():Vector.<uint> { return _nums; }

		/**
		 * frame label
		 */		
		public function get labels():Vector.<String> { return _labels; }


	}
}