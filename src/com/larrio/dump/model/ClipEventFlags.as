package com.larrio.dump.model
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.dump.utils.assertTrue;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 25, 2012 1:17:12 PM
	 */
	public class ClipEventFlags implements ICodec
	{
		private var _keyUp:uint;
		private var _keyDown:uint;
		private var _keyPress:uint;
		
		private var _mouseUp:uint;
		private var _mouseDown:uint;
		private var _mouseMove:uint;
		
		private var _unload:uint;
		private var _load:uint;
		
		private var _enterFrame:uint;
		
		private var _dragOver:uint;
		private var _dragOut:uint;
		
		private var _rollOut:uint;
		private var _rollOver:uint;
		
		private var _releaseOutside:uint;
		private var _release:uint;
		private var _press:uint;
		
		private var _initialize:uint;
		
		private var _data:uint;
		
		private var _construct:uint;
		
		/**
		 * 构造函数
		 * create a [ClipEventFlags] object
		 */
		public function ClipEventFlags()
		{
			
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_keyUp = decoder.readUB(1);
			_keyDown = decoder.readUB(1);
			
			_mouseUp = decoder.readUB(1);
			_mouseDown = decoder.readUB(1);
			_mouseMove = decoder.readUB(1);
			
			_unload = decoder.readUB(1);
			_enterFrame = decoder.readUB(1);
			_load = decoder.readUB(1);
			
			_dragOver = decoder.readUB(1);
			
			_rollOut = decoder.readUB(1);
			_rollOver = decoder.readUB(1);
			
			_releaseOutside = decoder.readUB(1);
			_release = decoder.readUB(1);
			_press = decoder.readUB(1);
			
			_initialize = decoder.readUB(1);
			_data = decoder.readUB(1);
			
			assertTrue(decoder.readUB(5) == 0)
			
			_construct = decoder.readUB(1);
			
			_keyPress = decoder.readUB(1);
			_dragOut = decoder.readUB(1);
			
			assertTrue(decoder.readUB(8) == 0);
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			encoder.writeUB(_keyUp, 1);
			encoder.writeUB(_keyDown, 1);
			
			encoder.writeUB(_mouseUp, 1);
			encoder.writeUB(_mouseDown, 1);
			encoder.writeUB(_mouseMove, 1);
			
			encoder.writeUB(_unload, 1);
			encoder.writeUB(_enterFrame, 1);
			encoder.writeUB(_load, 1);
			
			encoder.writeUB(_dragOver, 1);
			
			encoder.writeUB(_rollOut, 1);
			encoder.writeUB(_rollOver, 1);
			
			encoder.writeUB(_releaseOutside, 1);
			encoder.writeUB(_release, 1);
			encoder.writeUB(_press, 1);
			
			encoder.writeUB(_initialize, 1);
			encoder.writeUB(_data, 1);
			
			encoder.writeUB(0, 5);
			
			encoder.writeUB(_construct, 1);
			encoder.writeUB(_dragOut, 1);
			
			encoder.writeUB(0, 8);
			encoder.flush();
		}

		/**
		 * Key up event
		 */		
		public function get keyUp():uint { return _keyUp; }

		/**
		 * Key down event
		 */		
		public function get keyDown():uint { return _keyDown; }

		/**
		 * Key press event
		 */		
		public function get keyPress():uint { return _keyPress; }

		/**
		 * Mouse up event
		 */		
		public function get mouseUp():uint { return _mouseUp; }

		/**
		 * Mouse down event
		 */		
		public function get mouseDown():uint { return _mouseDown; }

		/**
		 * Mouse move event
		 */		
		public function get mouseMove():uint { return _mouseMove; }

		/**
		 * Clip unload event
		 */		
		public function get unload():uint { return _unload; }

		/**
		 * Clip load event
		 */		
		public function get load():uint { return _load; }

		/**
		 * Frame event
		 */		
		public function get enterFrame():uint { return _enterFrame; }

		/**
		 * Mouse drag over event
		 */		
		public function get dragOver():uint { return _dragOver; }

		/**
		 * Mouse drag out event
		 */		
		public function get dragOut():uint { return _dragOut; }

		/**
		 * mouse rollout event
		 */		
		public function get rollOut():uint { return _rollOut; }

		/**
		 * mouse rollover event
		 */		
		public function get rollOver():uint { return _rollOver; }

		/**
		 * mouse release outside event
		 */		
		public function get releaseOutside():uint { return _releaseOutside; }

		/**
		 * mouse release inside event
		 */		
		public function get release():uint { return _release; }

		/**
		 * mouse press event
		 */		
		public function get press():uint { return _press; }

		/**
		 * initialize event
		 */		
		public function get initialize():uint { return _initialize; }

		/**
		 * Data received event
		 */		
		public function get data():uint { return _data; }

		/**
		 * construct event
		 */		
		public function get construct():uint { return _construct; }

	}
}