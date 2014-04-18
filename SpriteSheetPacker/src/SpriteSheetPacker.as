package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import Image.ImageCustomEvent;
	
	import Importer.ImageLoader;
	
	import RectanglePacker.RectanglePacker;
	import RectanglePacker.stRect;
	
	import SpriteSheet.SpriteSheetMaker;
	
	
	public class SpriteSheetPacker extends Sprite
	{		
		public function SpriteSheetPacker()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var imageLoader:ImageLoader = new ImageLoader();
			imageLoader.LoadImages();			
			imageLoader.addEventListener( ImageLoader.EVENT_LOAD_ALL, onAllImageLoad ); 
		}
		
		public function onAllImageLoad(event:ImageCustomEvent):void
		{
			var spriteSheetMaker:SpriteSheetMaker = new SpriteSheetMaker();
			var sheet:Sprite = spriteSheetMaker.MakeSpriteSheet(event.imageInfoVec);
			
			addChild(sheet);
		}
	}
}