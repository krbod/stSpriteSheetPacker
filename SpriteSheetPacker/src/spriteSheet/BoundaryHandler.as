package spriteSheet
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 스프라이트 시트에 있는 각각의 스프라이트 이미지를 클릭했을 경우
	 * 경계를 나타내기 위한 클래스
	 */
	public class BoundaryHandler
	{
		private var _boundary:Shape;		// graphics 객체를 이용해 경계를 나타내기 위한 객체
		private var _oldSprite:Sprite;
		
		public function BoundaryHandler()
		{
			_boundary = new Shape();
		}
		
		/**
		 * 모든 이미지 주변에 경계를 표시합니다. 
		 * @param spriteInfoVec 각 이미지의 정보를 담고 있는 벡터
		 * @param spriteSheetSprite 이미지들을 포함하고 있는 Sprite 객체 (이미지들의 parent sprite)
		 */
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
		
		/**
		 *  모든 이미지 주변에 그린 경계를 지웁니다.
		 */
		public function EraseAllBoundary():void
		{
			_boundary.graphics.clear();
		}
		
		/**
		 * 스프라이트 시트 이미지 위에 있는 하나의 스프라이트를 
		 * 클릭했을 경우 스프라이트 가장자리로 경계를 그립니다.
		 * @param event 클릭한 스프라이트에 대한 마우스 이벤트 
		 */
		public function OnClick(event:MouseEvent):void
		{
			// 이미지를 다시 클릭할 경우 경계를 지움
			if( _oldSprite != null && _oldSprite == event.target as Sprite )
			{
				_boundary.graphics.clear();
				_oldSprite = null;
				return;
			}
			else
			{
				_oldSprite = event.target as Sprite;
			}
			
			var bmpContainer:Sprite = Sprite(event.target);			
			var bmp:Bitmap = Bitmap(bmpContainer.getChildAt(0));
			
			// 이전에 그린 Boundary 를 지움
			_boundary.graphics.clear();			
			
			DrawRectangle(bmp.x, bmp.y, bmp.x + bmp.width, bmp.y + bmp.height);		
			bmpContainer.addChild(_boundary);
		}
		
		/**
		 * 경계를 그립니다. 
		 * @param x1 left
		 * @param y1 top
		 * @param x2 right
		 * @param y2 bottom
		 * 
		 */
		private function DrawRectangle(x1:int, y1:int, x2:int, y2:int):void
		{						
			// 새로운 Boundary 를 그림
			_boundary.graphics.lineStyle(2, 0xff0000);
			
			// 테두리 라인을 그림
			_boundary.graphics.moveTo(x1, y1);			// left, top
			
			_boundary.graphics.lineTo(x2, y1);				// left, top -> right, top	
			_boundary.graphics.lineTo(x2,y2);				// right, top -> right, bottom
			_boundary.graphics.lineTo(x1,y2);				// right, bottom -> left, bottom
			_boundary.graphics.lineTo(x1,y1);				// left, bottom -> left, top		
			
			// 테두리 안을 채움
			_boundary.graphics.beginFill(0xff0000, 0.3);
			_boundary.graphics.drawRect(x1, y1, x2-x1, y2-y1);
			_boundary.graphics.endFill();
		}
		
		/**
		 * 사용한 자원을 해제합니다. 
		 */
		public function Clear():void
		{
			_boundary.graphics.clear();
			_boundary = null;
		}
	}
}