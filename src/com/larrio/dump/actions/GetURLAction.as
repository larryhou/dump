package com.larrio.dump.actions
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 24, 2012 10:53:18 PM
	 */
	public class GetURLAction extends SWFAction
	{
		public static const TYPE:uint = ActionType.GET_URL;
		
		private var _url:String;
		private var _target:String;
		
		/**
		 * 构造函数
		 * create a [GetURLAction] object
		 */
		public function GetURLAction()
		{
			
		}
		
		/**
		 * 解码DoAction 
		 * @param decoder	解码器
		 */		
		override public function decodeAction(decoder:FileDecoder):void
		{
			_url = decoder.readSTR();
			_target = decoder.readSTR();
		}
		
		/**
		 * 编码DoAction
		 * @param encoder	编码器
		 */		
		override public function encodeAction(encoder:FileEncoder):void
		{
			encoder.writeSTR(_url);
			encoder.writeSTR(_target);
		}

		/**
		 * url string
		 */		
		public function get url():String { return _url; }

		/**
		 * target string
		 */		
		public function get target():String { return _target; }


	}
}