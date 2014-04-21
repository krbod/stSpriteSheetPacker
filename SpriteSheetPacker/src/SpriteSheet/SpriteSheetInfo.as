package SpriteSheet
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import Image.ImageFileInfo;

	public class SpriteSheetInfo
	{
		// 스프라이트 시트 크기
		private var _width:int;		
		private var _height:int;
		
		// 스프라이트 시트 전체에 대한  Sprite 객체
		private var _spriteSheetSprite:Sprite;
		
		// 각각 이미지에 대한 정보를 저장하고 있는 벡터
		private var _spriteInfoVec:Vector.<SpriteInfo>;
		
		// 이미지를 클릭했을 경우 경계를 나타내는 객체
		private var _boundaryHandler:BoundaryHandler;
		
				
		public function SpriteSheetInfo()
		{
			_spriteInfoVec = new Vector.<SpriteInfo>;		
			_spriteSheetSprite = new Sprite();	
			_boundaryHandler = new BoundaryHandler();
		}
		
		public function AddSprite(bmp:Bitmap, imageInfo:ImageFileInfo):void
		{
			// 스프라이트 객체를 생성해서 스프라이트 시트 Sprite 객체에 추가
			var sprite:Sprite = new Sprite();
			sprite.addChild(bmp);
			_spriteSheetSprite.addChild(sprite);
			
			// Boundary Handler 객체에 클릭 이벤트 등록
			_boundaryHandler.SetClickEventListener(sprite);
			
			// 스프라이트 정보 생성
			var spriteInfo:SpriteInfo = new SpriteInfo(bmp.x, bmp.y, 
																			bmp.width/_width, 	// uv width
																			bmp.height/_height,  // uv height
																			imageInfo); 
			_spriteInfoVec.push(spriteInfo);
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