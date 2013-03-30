package com.larrio.dump.flash.display.font
{
	import com.larrio.dump.model.shape.Shape;
	import com.larrio.dump.tags.DefineFont2Tag;
	
	import flash.utils.Dictionary;
	
	/**
	 * 嵌入字体收集器
	 * @author doudou
	 * @createTime Mar 30, 2013 4:56:24 PM
	 */
	public class GlyphCollector
	{
		private var _name:String;
		private var _map:Dictionary;
		
		private var _glyphs:Vector.<Shape>;
		
		/**
		 * 构造函数
		 * create a [FontCollector] object
		 */
		public function GlyphCollector(tag:DefineFont2Tag = null)
		{
			tag && load(tag);
		}
		
		/**
		 * 装在字体Tag数据 
		 * @param tag	DefaultFont2Tag对象
		 */		
		public function load(tag:DefineFont2Tag):void
		{
			_name = tag.name;
			_map = new Dictionary(false);
			
			_glyphs = tag.glyphs.concat();
			for (var i:int = 0, length:uint = _glyphs.length; i < length; i++)
			{
				_map[tag.codeTable[i]] = _glyphs[i];
			}
			
			_glyphs.fixed = true;
		}
		
		/**
		 * 获取单个字符的矢量数据
		 * @param char	单个字符
		 */		
		public function getGlyphByChar(char:String):Shape
		{
			if (!char) return null;
			
			return _map[char.charCodeAt(0)] as Shape;
		}
		
		/**
		 * 获取多个字符的矢量数据列表 
		 * @param chars	字符串
		 */		
		public function getGlyphs(chars:String):Vector.<Shape>
		{
			if (!chars) return null;
			
			var result:Vector.<Shape> = new Vector.<Shape>;
			for (var i:int = 0, length:uint = chars.length; i < length; i++)
			{
				result.push(_map[chars.charCodeAt(i)] as Shape);
			}
			
			result.fixed = true;
			return result;
		}

		/**
		 * Tag定义所有字符矢量数据
		 */		
		public function get glyphs():Vector.<Shape> { return _glyphs; }

		/**
		 * 字体名称 
		 */		
		public function get name():String { return _name; }
		
	}
}