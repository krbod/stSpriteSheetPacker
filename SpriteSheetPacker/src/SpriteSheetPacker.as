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
	
	
	public class SpriteSheetPacker extends Sprite
	{
		private var stageWidth:int = 2048;
		private var stageHeight:int = 2048;
		
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
			var rectanglePacker:RectanglePacker = new RectanglePacker(stageWidth, stageHeight);
			
			for(var i:uint = 0; i<event.imageInfoVec.length; ++i)
			{
				var rect:stRect = rectanglePacker.InsertNewRect(new stRect(0, 0, event.imageInfoVec[i].bmpData.width, event.imageInfoVec[i].bmpData.height));
				var bitmap:Bitmap = new Bitmap(event.imageInfoVec[i].bmpData);
				bitmap.x = rect.x;
				bitmap.y = rect.y;
				
				addChild(bitmap);
				
				trace(event.imageInfoVec[i].fileName + " - width:" + event.imageInfoVec[i].bmpData.width + " height:" + event.imageInfoVec[i].bmpData.height);
			}
			
			rectanglePacker.Clean();
			rectanglePacker = null;
		}
	}
}