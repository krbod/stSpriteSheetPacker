package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import Image.ImageCustomEvent;	
	import RectanglePacker.RectanglePackerTester;
	
	
	public class SpriteSheetPacker extends Sprite
	{
		public function SpriteSheetPacker()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var recTest:RectanglePackerTester = new RectanglePackerTester();
			addChild(recTest);
		}
		
		public function onAllImageLoad(e:ImageCustomEvent):void
		{
			for(var i:uint = 0; i<e.imageInfoVec.length; ++i)
			{
				var bmp:Bitmap = new Bitmap(e.imageInfoVec[i].bmpData);
				addChild(bmp);
			}
		}
	}
}