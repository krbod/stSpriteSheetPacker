package SpriteSheet
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import Image.ImageInfo;
	
	import RectanglePacker.RectanglePacker;
	import RectanglePacker.stRect;

	/**
	 * 이미지 정보를 가진 벡터로부터 스프라이트 시트를 제작합니다.
	 * 
	 */
	public class SpriteSheetMaker
	{
		private var _spriteInfoVec:Vector.<SpriteInfo>;;
		
		public function SpriteSheetMaker()
		{
			_spriteInfoVec = new Vector.<SpriteInfo>;
		}
		
		public function get sprites():Vector.<SpriteInfo>
		{
			return _spriteInfoVec;
		}
		
		/**
		 * 스프라이트시트를 제작합니다.  
		 * @param imageInfoVec 스프라이트 시트에 저장할 이미지 정보가 들어 있는 벡터
		 * @return 스프라이트 시트 이미지가 저장되어 있는 Sprite 객체
		 * 
		 */
		public function MakeSpriteSheet(imageInfoVec:Vector.<ImageInfo>):Sprite
		{			
			var spritesContainer:Sprite = new Sprite();
			
			var rectanglePacker:RectanglePacker = new RectanglePacker();			
			var bitmapVec:Vector.<Bitmap> = new Vector.<Bitmap>;
			
			for(var i:uint = 0; i<imageInfoVec.length; ++i)
			{
				var rect:stRect = rectanglePacker.InsertNewRect(new stRect(0, 0, imageInfoVec[i].bmpData.width, imageInfoVec[i].bmpData.height));
				
				// 스프라이트 시트 전체 이미지 크기가 작아서 더이상 추가를 못 할경우 
				// 이미지를 2배 늘려서 다시 저장
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
				
				var bitmap:Bitmap = new Bitmap(imageInfoVec[i].bmpData);				
				bitmap.x = rect.x;
				bitmap.y = rect.y;
				bitmapVec.push(bitmap);
			}
			
			// 비트맵 출력 및 스프라이트 정보 저장
			var spriteSize:int = rectanglePacker.getSize();
			for(var i:uint = 0; i<bitmapVec.length; ++i)
			{
				spritesContainer.addChild(bitmapVec[i]);
				
				var spriteInfo:SpriteInfo = new SpriteInfo(bitmapVec[i].x, bitmapVec[i].y, 
																				bitmapVec[i].width/spriteSize, 
																				bitmapVec[i].height/spriteSize, 
																				imageInfoVec[i]);
				_spriteInfoVec.push(spriteInfo);
			}
			
			rectanglePacker.Clean();
			rectanglePacker = null;
			
			return spritesContainer;
		}
	}
}