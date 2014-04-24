package spriteSheet
{
	import flash.display.Bitmap;
	
	import spriteSheet.rectanglePacker.RectanglePacker;
	import spriteSheet.rectanglePacker.stRect;
	
	import spriteSheet.image.ImageFileInfo;

	/**
	 * 이미지 정보를 가진 벡터로부터 스프라이트 시트를 제작합니다.
	 */
	public class SpriteSheetMaker
	{				
		private const SPACING:int = 2;	// 스프라이트 간의 여백 ( bleeding 방지 )
		
		/**
		 * 스프라이트시트를 제작합니다.  
		 * @param imageInfoVec 스프라이트 시트에 저장할 ImageFileInfo 벡터
		 * @return 스프라이트 시트 이미지가 저장되어 있는 Sprite 객체
		 */
		public function MakeSpriteSheet(imageFileInfoVec:Vector.<ImageFileInfo>):SpriteSheetInfo
		{						
			var rectPacker:RectanglePacker = new RectanglePacker(SPACING);			
			var bitmapVec:Vector.<Bitmap> = new Vector.<Bitmap>;
			var spriteSheetInfo:SpriteSheetInfo = new SpriteSheetInfo();
			
			// 각 이미지들을 넓이를 비교해 정렬
			imageFileInfoVec.sort(SortWithSize);
			
			// 스프라이트 시트 이미지의 추측 최소 사이즈를 구함
			rectPacker.SetSize(SpeculateMinSize(imageFileInfoVec));
			
			for(var i:uint = 0; i<imageFileInfoVec.length; ++i)
			{
				// 이미지 파일의 크기를 읽어 Rectangle Packing 알고리즘 적용
				var rect:stRect = rectPacker.InsertNewRect(new stRect(0, 0, imageFileInfoVec[i].bmpData.width, imageFileInfoVec[i].bmpData.height));
				
				
				// 스프라이트 시트 전체 이미지 크기가 작아서 더이상 추가를 못 할경우 
				// 이미지를 2배 늘려서 다시 저장
				if( rect == null )
				{
					rectPacker.Resize();	// 2배 늘림
					i = -1;
					
					while(bitmapVec.length)	// 비트맵 벡터 해제
					{
						bitmapVec.pop();
					}
										
					continue;
				}
				
				// BitmapData 를 통해 Bitmap 객체 생성
				var bitmap:Bitmap = new Bitmap(imageFileInfoVec[i].bmpData);				
				bitmap.x = rect.x + SPACING;
				bitmap.y = rect.y + SPACING;
				bitmapVec.push(bitmap);
			}
			
			spriteSheetInfo.width = rectPacker.spriteWidth;
			spriteSheetInfo.height = rectPacker.spriteHeight;
						
			// 스프라이트 시트에 각각 이미지에 대한 정보를 저장
			for(var i:uint = 0; i<bitmapVec.length; ++i)
			{
				spriteSheetInfo.AddSprite(bitmapVec[i], imageFileInfoVec[i]);
			}
			
			// 사용한 자원 해제
			rectPacker.Clear();
			rectPacker = null;
			
			return spriteSheetInfo;
			
		}
		
		/**
		 * 벡터 sort 함수에서 사용할 이미지의 넓이 비교 알고리즘 
		 * @param lhs 비교할 이미지의 ImageFileInfo 객체
		 * @param rhs 비교할 이미지의 ImageFileInfo 객체
		 * @return 비교후 결과값
		 */
		private function SortWithSize(lhs:ImageFileInfo, rhs:ImageFileInfo):int
		{
			var size_lhs:int = lhs.bmpData.width * lhs.bmpData.height;
			var size_rhs:int = rhs.bmpData.width * rhs.bmpData.height;
			
			if( size_lhs > size_rhs )
			{
				return -1;
			}
			else if( size_rhs > size_lhs )
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 전제 이미지의 넓이를 구해서 최소 스프라이트 시트 사이즈를 추측합니다. 
		 * @param imageVec 모든 이미지 정보를 포함한 벡터 객체
		 * @return Array 객체 ( [0] : width, [1] : height )
		 * 
		 */
		private function SpeculateMinSize(imageVec:Vector.<ImageFileInfo>):Array
		{
			var totalArea:int; 
			for(var i:uint = 0; i<imageVec.length; ++i)
			{
				totalArea += imageVec[i].bmpData.width * imageVec[i].bmpData.height;
			}
			
			var speculation:Array = [2,2];			
			while( speculation[0] * speculation[1] < totalArea )
			{
				if( speculation[0] == speculation[1] )
				{
					speculation[1] *= 2;
				}
				else if( speculation[0] < speculation[1] )
				{
					speculation[0] *= 2;
				}
			}
						
			return speculation;
		}
		
	}
}