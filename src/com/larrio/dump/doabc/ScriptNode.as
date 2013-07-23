package com.larrio.dump.doabc
{
	import com.larrio.dump.interfaces.IScript;
	
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author doudou
	 * @createTime Jul 24, 2013 12:34:32 AM
	 */
	public class ScriptNode implements IScript
	{
		private var _slots:Vector.<TraitInfo>;
		private var _methods:Vector.<TraitInfo>;
		private var _classes:Vector.<TraitInfo>;
		
		private var _map:Dictionary;
		
		private var _belong:IScript;
		private var _children:Vector.<IScript>;
		
		/**
		 * 构造函数
		 * create a [ScriptNode] object
		 */
		public function ScriptNode()
		{
			_slots = new Vector.<TraitInfo>;
			_methods = new Vector.<TraitInfo>;
			_classes = new Vector.<TraitInfo>;
			
			_map = new Dictionary();
			_children = new Vector.<IScript>;
		}
		
		/**
		 * 添加子脚本 
		 * @param script IScript脚本对象
		 */		
		public function addScript(script:IScript):void
		{
			if (_children.indexOf(script) < 0)
			{
				_children.push(script);
			}
		}
		
		/**
		 * 移除特征对象 
		 * @param script IScript脚本对象
		 */		
		public function removeScript(script:IScript):void
		{
			var index:uint = _children.indexOf(script);
			if (index >= 0) _children.splice(index, 1);
		}
		
		/**
		 * 添加特征对象 
		 * @param trait	特征对象
		 * @return 0:变量 1:函数 2:类
		 */		
		public function addTrait(trait:TraitInfo):uint
		{
			_map[trait.data.id] = trait;
			
			// 特征归类
			switch (trait.kind & 0xF)
			{
				case TraitType.GETTER:
				case TraitType.SETTER:
				case TraitType.METHOD:
				case TraitType.FUNCTION:
				{
					_methods.push(trait);
					return 1;
				}
					
				case TraitType.CLASS:
				{
					_classes.push(trait);
					return 2;
				}

					
				default:
				{
					_slots.push(trait);
					break;
				}
			}
			
			return 0;
		}
		
		/**
		 * 获取特征 
		 * @param id 特征ID
		 */		
		public function getTrait(id:uint):TraitInfo
		{
			return _map[id] as TraitInfo;
		}

		/**
		 * 变量列表
		 */		
		public function get slots():Vector.<TraitInfo> { return _slots; }

		/**
		 * 方法列表
		 */		
		public function get methods():Vector.<TraitInfo> { return _methods; }
		
		/**
		 * 类列表
		 */		
		public function get classes():Vector.<TraitInfo> { return _classes; }

		/**
		 * 所属脚本容器
		 */		
		public function get belong():IScript { return _belong; }
		public function set belong(value:IScript):void
		{
			if (value)
			{
				value.addScript(this);
			}
			else
			{
				_belong && _belong.removeScript(this);
			}
			
			_belong = value;
		}

		/**
		 * 子脚本对象
		 */		
		public function get children():Vector.<IScript> { return _children; }

	}
}