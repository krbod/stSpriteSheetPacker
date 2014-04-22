package spriteSheet
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 스프라이트 시트에 있는 각각의 스프라이트 이미지를 클릭했을 경우
	 * 경계를 나타내기 위한 클래스
	 */
	public class BoundaryHandler
	{
		private var _boundary:MovieClip;		// graphics 객체를 이용해 경계를 나타내기 위한 객체
		
		public function BoundaryHandler()
		{
			_boundary = new MovieClip();
		
		}
		
		public function DrawAllBoundary(spriteInfoVec:Vector.<SpriteInfo>, spriteSheetSprite:Sprite):void
		{
			_boundary.graphics.clear();		
			
			var spriteCount:uint = spriteInfoVec.length;
			for(var i:uint = 0; i<spriteCount; ++i)
			{
				DrawRectangle(	spriteInfoVec[i].x, 
										spriteInfoVec[i].y, 
										spriteInfoVec[i].x + spriteInfoVec[i].imageInfo.bmpData.width, 
										spriteInfoVec[i].y + spriteInfoVec[i].imageInfo.bmpData.height);
			}
			
			spriteSheetSprite.addChild(_boundary);
		}
		
		public function EraseAllBoundary():void
		{
			_boundary.graphics.clear();
		}
		
		/**
		 * 스프라이트 시트 이미지 위에 있는 하나의 스프라이트를 
		 * 클릭했을 경우 스프라이트 가장자리로 경계를 그립니다.
		 * @param event 클릭한 스프라이트에 대한 마우스 이벤트 
		 * 
		 */
		public function OnClick(event:MouseEvent):void
		{
			var bmpContainer:Sprite = Sprite(event.target);			
			var bmp:Bitmap = Bitmap(bmpContainer.getChildAt(0));
			
			// 이전에 그린 Boundary 를 지움
			_boundary.graphics.clear();			
			
			DrawRectangle(bmp.x, bmp.y, bmp.x + bmp.width, bmp.y + bmp.height);		
			bmpContainer.addChild(_boundary);
		}
		
		private function DrawRectangle(x1:int, y1:int, x2:int, y2:int):void
		{						
			// 새로운 Boundary 를 그림
			_boundary.graphics.lineStyle(2, 0xff0000);
			
			_boundary.graphics.moveTo(x1, y1);			// left, top
			
			_boundary.graphics.lineTo(x2, y1);				// left, top -> right, top	
			_boundary.graphics.lineTo(x2,y2);				// right, top -> right, bottom
			_boundary.graphics.lineTo(x1,y2);				// right, bottom -> left, bottom
			_boundary.graphics.lineTo(x1,y1);				// left, bottom -> left, top			
		}
	}
}