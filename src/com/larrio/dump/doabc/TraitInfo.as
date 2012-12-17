package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.ICodec;
	import com.larrio.utils.FileDecoder;
	import com.larrio.utils.FileEncoder;
	import com.larrio.utils.assertTrue;
	
	/**
	 * 函数特征信息
	 * @author larryhou
	 * @createTime Dec 17, 2012 9:54:37 AM
	 */
	public class TraitInfo implements ICodec
	{
		private var _name:uint;
		private var _kind:uint;
		
		private var _data:TraitData;
		
		private var _metadatas:Vector.<uint>;
		
		
		private var _constants:ConstantPool;
		
		/**
		 * 构造函数
		 * create a [TraitInfo] object
		 */
		public function TraitInfo(constants:ConstantPool)
		{
			_constants = constants;
		}
		
		/**
		 * 二进制解码 
		 * @param decoder	解码器
		 */		
		public function decode(decoder:FileDecoder):void
		{
			_name = decoder.readEU30();
			_kind = decoder.readUI8();
			
			_data = new TraitData();
			switch (_kind & 0xF)
			{
				case TraitType.TRAIT_SLOT:
				case TraitType.TRAIT_CONST:
				{
					_data.id = decoder.readEU30();
					_data.type = decoder.readEU30();
					_data.index = decoder.readEU30();
					if (_data.index)
					{
						_data.kind = decoder.readUI8();
					}
					
					break;
				}
					
				case TraitType.TRAIT_CLASS:
				{
					_data.id = decoder.readEU30();
					_data.classi = decoder.readEU30();
					break;
				}
					
				default:
				{
					_data.id = decoder.readEU30();
					_data.method = decoder.readEU30();
					break;
				}
			}
			
			var _length:uint, i:int;
			if (((_kind >> 4) & TraitAttriType.METADATA) == TraitAttriType.METADATA)
			{
				_length = decoder.readEU30();
				_metadatas = new Vector.<uint>(_length, true);
				for (i = 0; i < _length; i++)
				{
					_metadatas[i] = decoder.readEU30();
				}
			}
		}
		
		/**
		 * 二进制编码 
		 * @param encoder	编码器
		 */		
		public function encode(encoder:FileEncoder):void
		{
			
		}
	}
}

class TraitData
{
	/**
	 * slot & disp 
	 */	
	public var id:uint;
	
	/**
	 * 指向multinames常量数组的索引 
	 */	
	public var type:uint;
	
	public var index:uint;
	public var kind:uint;
	
	/**
	 * 指向classes数组的索引 
	 */	
	public var classi:uint;
	
	/**
	 * 指向methods常量数组的索引 
	 */	
	public var method:uint;
}