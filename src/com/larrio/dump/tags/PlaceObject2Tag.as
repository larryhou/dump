package com.larrio.dump.tags
{
	import com.larrio.dump.codec.FileDecoder;
	import com.larrio.dump.codec.FileEncoder;
	import com.larrio.dump.model.ClipActions;
	import com.larrio.dump.model.ColorTransformRecord;
	import com.larrio.dump.model.MatrixRecord;
	
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Dec 26, 2012 9:50:56 AM
	 */
	public class PlaceObject2Tag extends PlaceObjectTag
	{
		public static const TYPE:uint = TagType.PLACE_OBJECT2;
		
		protected var _hasClipActions:uint;
		protected var _hasMaskDepth:uint;
		
		protected var _hasName:uint;
		protected var _hasRatio:uint;
		protected var _hasColorTransform:uint;
		protected var _hasMatrix:uint;
		protected var _hasCharacter:uint;
		protected var _moved:uint;
		
		protected var _morphRatio:uint;
		protected var _name:String;
		
		protected var _maskDepth:uint;
		protected var _clipActions:ClipActions;
		
		
		/**
		 * 构造函数
		 * create a [PlaceObject2Tag] object
		 */
		public function PlaceObject2Tag()
		{
			
		}
		
		/**
		 * 对TAG二进制内容进行解码 
		 * @param decoder	解码器
		 */		
		override protected function decodeTag(decoder:FileDecoder):void
		{
			_hasClipActions = decoder.readUB(1);
			_hasMaskDepth = decoder.readUB(1);
			_hasName = decoder.readUB(1);
			_hasRatio = decoder.readUB(1);
			_hasColorTransform = decoder.readUB(1);
			_hasMatrix = decoder.readUB(1);
			_hasCharacter = decoder.readUB(1);
			_moved = decoder.readUB(1);
			
			depth = decoder.readUI16();
			if (_hasCharacter)
			{
				_character = decoder.readUI16();
			}
			
			if (_hasMatrix)
			{
				_matrix = new MatrixRecord();
				_matrix.decode(decoder);
			}
			
			if (_hasColorTransform)
			{
				_colorTransform = new ColorTransformRecord(true);
				_colorTransform.decode(decoder);
			}
			
			if (_hasRatio)
			{
				_morphRatio = decoder.readUI16();
			}
			
			if (_hasName)
			{
				_name = decoder.readSTR();
			}
			
			if (_hasMaskDepth)
			{
				_maskDepth = decoder.readUI16();
			}
			
			if (_hasClipActions)
			{
				_clipActions = new ClipActions();
				_clipActions.decode(decoder);
			}
			
		}
		
		/**
		 * 对TAG内容进行二进制编码 
		 * @param encoder	编码器
		 */		
		override protected function encodeTag(encoder:FileEncoder):void
		{
			encoder.writeUB(_hasClipActions, 1);
			encoder.writeUB(_hasMaskDepth, 1);
			encoder.writeUB(_hasName, 1);
			encoder.writeUB(_hasRatio, 1);
			encoder.writeUB(_hasColorTransform, 1);
			encoder.writeUB(_hasMatrix, 1);
			encoder.writeUB(_hasCharacter, 1);
			encoder.writeUB(_moved, 1);
			
			encoder.writeUI16(depth);
			
			if (_hasCharacter)
			{
				encoder.writeUI16(_character);
			}
			
			if (_hasMatrix)
			{
				_matrix.encode(encoder);
			}
			
			if (_hasColorTransform)
			{
				_colorTransform.encode(encoder);
			}
			
			if (_hasRatio)
			{
				encoder.writeUI16(_morphRatio);
			}
			
			if (_hasName)
			{
				encoder.writeSTR(_name);
			}
			
			if (_hasMaskDepth)
			{
				encoder.writeUI16(_maskDepth);
			}
			
			if (_hasClipActions)
			{
				_clipActions.encode(encoder);
			}
		}
		
		/**
		 * 字符串输出
		 */		
		override public function toString():String
		{
			var result:XML = new XML("<PlaceObject2Tag/>");
			result.@depth = depth;
			if (_hasName)
			{
				result.@name = _name;
			}
			
			if (_hasCharacter)
			{
				result.@character = _character;
			}
			
			if (_hasRatio)
			{
				result.@ratio = _morphRatio;
			}
			
			if (_hasMatrix)
			{
				result.appendChild(new XML(_matrix.toString()));
			}
			
			if (_hasColorTransform)
			{
				result.appendChild(new XML(_colorTransform.toString()));
			}
			
			if (_hasMaskDepth)
			{
				result.@maskDepth = _maskDepth;
			}
			
			return result.toXMLString();	
		}
		
		/**
		 * Defines a character to be moved
		 *  • PlaceFlagMove = 0 and PlaceFlagHasCharacter = 1
		 *	  A new character (with ID of CharacterId) is placed on the display list at the specified depth. 
		 *	  Other fields set the attributes of this new character.
		 *	• PlaceFlagMove = 1 and PlaceFlagHasCharacter = 0
		 *	  The character at the specified depth is modified. Other fields modify the attributes of this character. 
		 *	  Because any given depth can have only one character, no CharacterId is required.
		 *	• PlaceFlagMove = 1 and PlaceFlagHasCharacter = 1
		 *	  The character at the specified Depth is removed, and a new character (with ID of CharacterId) is placed at that depth. 
		 *	  Other fields set the attributes of this new character.
		 */		
		public function get moved():Boolean { return Boolean(_moved); }
		public function set moved(value:Boolean):void
		{
			_moved = uint(value);
		}

		/**
		 * The Ratio field specifies a morph ratio for the character being added or modified. 
		 * This field applies only to characters defined with DefineMorphShape, and controls how far the morph has progressed. 
		 * A ratio of zero displays the character at the start of the morph. 
		 * A ratio of 65535 displays the character at the end of the morph. 
		 * For values between zero and 65535 Flash Player interpolates between the start and end shapes, and displays an in- between shape.
		 */		
		public function get morphRatio():uint { return _morphRatio; }
		public function set morphRatio(value:uint):void
		{
			_morphRatio = value;
			_hasRatio = 1;
		}

		/**
		 * The Name field specifies a name for the character being added or modified. 
		 * This field is typically used with sprite characters, and is used to identify the sprite for SetTarget actions. 
		 * It allows the main file (or other sprites) to perform actions inside the sprite
		 */		
		public function get name():String { return _name; }
		public function set name(value:String):void
		{
			_name = value;
			_hasName = 1;
		}

		/**
		 * The ClipDepth field specifies the top-most depth that will be masked by the character being added. 
		 * A ClipDepth of zero indicates that this is not a clipping character.
		 */	
		public function get maskDepth():uint { return _maskDepth; }
		public function set maskDepth(value:uint):void
		{
			_maskDepth = value;
			_hasMaskDepth = 1;
		}
		
		/**
		 * 显示对象对应特征ID
		 * The CharacterId field specifies the character to be added to the display list. 
		 * CharacterId is used only when a new character is being added. 
		 * If a character that is already on the display list is being modified, the CharacterId field is absent.
		 */		
		public function set charactor(value:uint):void
		{
			_character = value;
			_hasCharacter = 1;
		}
		
		/**
		 * 设置几何变形标记位
		 * The Matrix field specifies the position, scale and rotation of the character being added or modified.
		 */		
		override public function set matrix(value:Matrix):void
		{
			super.matrix = value;
			_hasMatrix = 1;
		}
		
		/**
		 * 设置颜色变换标记位
		 * The ColorTransform field specifies the color effect applied to the character being added or modified.
		 */		
		override public function set colorTransform(value:ColorTransform):void
		{
			super.colorTransform = value;
			_hasColorTransform = 1;
		}

		/**
		 * The ClipActions field, which is valid only for placing sprite characters, 
		 * defines one or more event handlers to be invoked when certain events occur.
		 */		
		public function get clipActions():ClipActions { return _clipActions; }
		public function set clipActions(value:ClipActions):void
		{
			_clipActions = value;
			_hasClipActions = 1;
		}

	}
}