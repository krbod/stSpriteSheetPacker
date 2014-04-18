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
			var rectanglePacker:RectanglePacker = new RectanglePacker();			
			var bitmapVec:Vector.<Bitmap> = new Vector.<Bitmap>;
			
			for(var i:uint = 0; i<event.imageInfoVec.length; ++i)
			{
				var rect:stRect = rectanglePacker.InsertNewRect(new stRect(0, 0, event.imageInfoVec[i].bmpData.width, event.imageInfoVec[i].bmpData.height));
				
				// 스프라이트 시트 전체 이미지 크기가 작아서 더이상 추가를 못 할경우 이미지를 2배 늘려서 다시 저장
				if( rect == null )
				{
					rectanglePacker.Resize();	// 2배 늘림
					i = -1;
					
					while(bitmapVec.length)	// 비트맵 벡터 해제
					{
						bitmapVec.pop();
					}
					
					continue;
				}
				
				var bitmap:Bitmap = new Bitmap(event.imageInfoVec[i].bmpData);				
				bitmap.x = rect.x;
				bitmap.y = rect.y;
				bitmapVec.push(bitmap);
				
				trace(event.imageInfoVec[i].fileName + " - width:" + event.imageInfoVec[i].bmpData.width + " height:" + event.imageInfoVec[i].bmpData.height);
			}
			
			// 비트맵 출력
			for(var i:uint = 0; i<bitmapVec.length; ++i)
			{
				addChild(bitmapVec[i]);
			}
			
			rectanglePacker.Clean();
			rectanglePacker = null;
		}
	}
}