package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 11:56:12 PM
	 */
	public class DefineFunctionAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.DEFINE_FUNCTION;
		
		private var _name:String;
		private var _params:Vector.<String>;
		
		private var _size:uint;
		
		/**
		 * 构造函数
		 * create a [DefineFunctionAction] object
		 */
		public function DefineFunctionAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			_name = decoder.readSTR();
			
			var length:uint = decoder.readUI16();
			
			_params = new Vector.<String>(length, true);
			for (var i:int = 0; i < length; i++)
			{
				_params[i] = decoder.readSTR();
			}
			
			_size = decoder.readUI16();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeSTR(_name);
			
			var length:uint = _params.length;
			encoder.writeUI16(length);
			
			for (var i:int = 0; i < length; i++)
			{
				encoder.writeSTR(_params[i]);
			}
			
			encoder.writeUI16(_size);
		}

		/**
		 * Function name, empty if anonymous
		 */		
		public function get name():String { return _name; }

		/**
		 * Parameter name
		 */		
		public function get params():Vector.<String> { return _params; }

		/**
		 * # of bytes of code that follow
		 */		
		public function get size():uint { return _size; }

	}
}