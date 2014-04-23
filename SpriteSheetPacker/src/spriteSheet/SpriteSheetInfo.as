package spriteSheet
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import spriteSheet.image.ImageFileInfo;

	/**
	 * 출력 결과물인 스프라이트 시트에 대한 정보를 가집니다. 
	 */
	public class SpriteSheetInfo
	{
		// 스프라이트 시트 크기
		private var _width:int;		
		private var _height:int;
		
		// 스프라이트 시트 전체에 대한  Sprite Container 객체
		private var _spriteSheetSprite:Sprite;
		
		// 각각 이미지에 대한 정보를 저장하고 있는 벡터
		private var _spriteInfoVec:Vector.<SpriteInfo>;
		
		// 이미지를 클릭했을 경우 경계를 나타내기 위한 객체
		private var _boundaryHandler:BoundaryHandler;
		
				
		public function SpriteSheetInfo()
		{
			_spriteInfoVec = new Vector.<SpriteInfo>;		
			_spriteSheetSprite = new Sprite();	
			_boundaryHandler = new BoundaryHandler();			
		}
		
		/**
		 * 새로운 스프라이트를 추가합니다. 
		 * @param bmp 새롭게 추가할 이미지의 Bitmap 정보
		 * @param imageFileInfo 새롭게 추가할 이미지의 파일 정보
		 */
		public function AddSprite(bmp:Bitmap, imageFileInfo:ImageFileInfo):void
		{
			// 스프라이트 객체를 생성해서 스프라이트 시트 Sprite 객체에 추가
			var sprite:Sprite = new Sprite();
			sprite.buttonMode = true;
			sprite.addChild(bmp);
			_spriteSheetSprite.addChild(sprite);
			
			// 객체에 클릭 이벤트 등록
			sprite.addEventListener(MouseEvent.CLICK, _boundaryHandler.OnClick);
			
			// 스프라이트 정보 생성
			var spriteInfo:SpriteInfo = new SpriteInfo(bmp.x, bmp.y, 
																			bmp.width, 
																			bmp.height,  
																			imageFileInfo); 
			_spriteInfoVec.push(spriteInfo);
		}
				
		/**
		 * 스프라이트 이미지 주위에 경계선을 긋습니다. 
		 */
		public function DrawAllBoundary():void
		{
			_boundaryHandler.DrawAllBoundary(_spriteInfoVec, _spriteSheetSprite);
		}
		
		/**
		 * 스프라이트 이미지 주위에 있는 경계선을 지웁니다.
		 */
		public function EraseAllBoundary():void
		{
			_boundaryHandler.EraseAllBoundary();
		}
		
		/**
		 * 사용한 자원을 해제 합니다.
		 */
		public function Clear():void
		{			
			// 스프라이트 이미지 정보 벡터 자원 해제
			while( _spriteInfoVec.length )
			{
				var spriteInfo:SpriteInfo = _spriteInfoVec.pop();
				spriteInfo.Clear();
				spriteInfo = null;
			}
			_spriteInfoVec = null;
			
			// 스프라이트 이미지의 마우스 클릭 이벤트 리스너 함수 해제 및 Bitmap 객체 해제
			for(var i:uint=0; i<_spriteSheetSprite.numChildren; ++i)
			{
				var bmp:Bitmap = Bitmap(Sprite(_spriteSheetSprite.getChildAt(i)).getChildAt(0));
				bmp.removeEventListener(MouseEvent.CLICK, _boundaryHandler.OnClick);
				bmp = null;				
			}
			
			// BoundaryHandler 자원 해제
			if( _boundaryHandler != null )
			{
				_boundaryHandler.Clear();
				_boundaryHandler = null;
			}
			
			_spriteSheetSprite = null;
		}
		
		
		/** Property */
		
		public function get width():int
		{
			return _width;
		}
		public function set width(width:int):void
		{
			_width = width;
		}
		
		public function get height():int
		{
			return _height;
		}
		public function set height(height:int):void
		{
			_height = height;
		}
		
		public function get spriteSheetImage():Sprite
		{
			return _spriteSheetSprite;
		}
		
		public function get spritesVec():Vector.<SpriteInfo>
		{
			return _spriteInfoVec;
		}
		
	}
}