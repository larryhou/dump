package demos.font 
{
	import com.larrio.dump.SWFile;
	import com.larrio.dump.flash.display.shape.canvas.GraphicsCanvas;
	import com.larrio.dump.flash.display.shape.collector.OutlineCollector;
	import com.larrio.dump.tags.DefineFont3Tag;
	import com.larrio.dump.tags.SWFTag;
	import com.larrio.dump.tags.TagType;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(width="1024", height="768")]
	
	
	/**
	 * 重绘导入字体
	 * @author doudou
	 * @createTime Mar 31, 2013 9:34:41 PM
	 */
	public class FontMain extends Sprite
	{
		[Embed(source="../../../libs/res01.swf", mimeType="application/octet-stream")]
		private var FileByteArray:Class;
		
		/**
		 * 构造函数
		 * create a [FontMain] object
		 */
		public function FontMain()
		{
			var collector:OutlineCollector;
			var swf:SWFile = new SWFile(new FileByteArray());
			
			var index:uint, row:uint; 
			var shape:Shape, fontTag:DefineFont3Tag;
			
			var container:Sprite = new Sprite();
			addChild(container);
			
			const LENGTH:uint = 1000;
			const ITEM_GAP:uint = LENGTH / 5;
			
			var position:Point = new Point();
			for each(var tag:SWFTag in swf.tags)
			{
				switch(tag.type)
				{
					case TagType.DEFINE_FONT3:
					{
						fontTag = tag as DefineFont3Tag;
						for (var i:int = 0; i < fontTag.glyphs.length; i++)
						{
							if (++index % 21 == 0)
							{
								row++;
								position.x = 0;
								if (shape) position.y += LENGTH + ITEM_GAP;
							}
							
							shape = new Shape();
							shape.graphics.clear();
							shape.graphics.beginFill(0xEE0000, 1);
							
							shape.x = position.x; 
							shape.y = position.y;
							
							position.x += LENGTH + ITEM_GAP;
							
							collector = new OutlineCollector(fontTag.glyphs[i]);
							collector.drawVectorOn(new GraphicsCanvas(shape.graphics));
							container.addChild(shape);
							
							shape.graphics.endFill();
						}
						break;
					}
				}
			}
			
			container.width = stage.stageWidth;
			container.scaleY = container.scaleX;
			
			var rect:Rectangle = container.getBounds(this);
			container.x = -rect.x;
			container.y = -rect.y;
		}
	}
}