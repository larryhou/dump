package com.larrio.dump.tags
{
	
	/**
	 * TAG工厂类
	 * @author larryhou
	 * @createTime Dec 16, 2012 12:24:04 PM
	 */
	public class TagFactory
	{
		
		/**
		 * 构造函数
		 * create a [TagFactory] object
		 */
		public function TagFactory()
		{
			
		}
		
		/**
		 * 工厂类生成SWFTag对象
		 * @param type	TAG类型
		 * @return SWFTag object
		 */		
		public static function create(type:int):SWFTag
		{
			switch(type)
			{
				case TagType.DO_ABC:
				{
					return new DoABCTag();
				}
				
				case TagType.SYMBOL_CLASS:
				{
					return new SymbolClassTag();
				}
					
				case TagType.FILE_ATTRIBUTES:
				{
					return new FileAttributesTag();
				}
					
				case TagType.FRAME_LABEL:
				{
					return new FrameLabelTag();
				}
					
				case TagType.END:
				{
					return new EndTag();
				}
					
				case TagType.SCRIPT_LIMITS:
				{
					return new ScriptLimitsTag();
				}
					
				case TagType.META_DATA:
				{
					return new MetadataTag();
				}
					
				case TagType.DEFINE_SCALING_GRID:
				{
					return new DefineScalingGridTag();
				}
					
				case TagType.PROTECT:
				{
					return new ProtectTag();
				}
				
				case TagType.SET_TABLE_INDEX:
				{
					return new SetTabIndexTag();
				}
					
				case TagType.ENABLE_DEBUGGER:
				{
					return new EnableDebuggerTag();
				}
					
				case TagType.ENABLE_DEBUGGER2:
				{
					return new EnableDebugger2Tag();
				}
					
				case TagType.SET_BACKGROUND_COLOR:
				{
					return new SetBackgroundColorTag();
				}
					
				case TagType.EXPORT_ASSETS:
				{
					return new ExportAssetsTag();
				}
					
				case TagType.IMPORT_ASSETS:
				{
					return new ImportAssetsTag();
				}
					
				case TagType.IMPORT_ASSETS2:
				{
					return new ImportAssets2Tag();
				}
					
				case TagType.DEFINE_SCENE_AND_FRAME_LABEL_DATA:
				{
					return new DefineSceneAndFrameLabelDataTag();
				}
					
				case TagType.DEFINE_BINARY_DATA:
				{
					return new DefineBinaryDataTag();
				}
					
				case TagType.SHOW_FRAME:
				{
					return new ShowFrameTag();
				}
					
				case TagType.PLACE_OBJECT:
				{
					return new PlaceObjectTag();
				}
					
				case TagType.PLACE_OBJECT2:
				{
					return new PlaceObject2Tag();
				}
					
				case TagType.PLACE_OBJECT3:
				{
					return new PlaceObject3Tag();
				}
					
				case TagType.REMOVE_OBJECT:
				{
					return new RemoveObjectTag();
				}
					
				case TagType.REMOVE_OBJECT2:
				{
					return new RemoveObject2Tag();
				}
					
				case TagType.JPEG_TABLES:
				{
					return new JPEGTablesTag();
				}
					
				case TagType.DEFINE_BITS:
				{
					return new DefineBitsTag();
				}
					
				case TagType.DEFINE_BITSJPEG2:
				{
					return new DefineBitsJPEG2Tag();
				}
					
				case TagType.DEFINE_BITSJPEG3:
				{
					return new DefineBitsJPEG3Tag();
				}
			}
			
			return new SWFTag();
		}		
	}
}