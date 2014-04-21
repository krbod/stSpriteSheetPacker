package SpriteSheet
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class SpriteSheetInfo
	{
		private var _width:int;
		private var _height:int;
		
		private var _spriteInfoVec:Vector.<SpriteInfo>;
		private var _spriteSheetSprite:Sprite;
				
		public function SpriteSheetInfo()
		{
			_spriteInfoVec = new Vector.<SpriteInfo>;		
			_spriteSheetSprite = new Sprite();	
		}
		
		public function AddSpriteInfo(spriteInfo:SpriteInfo):void
		{
			_spriteInfoVec.push(spriteInfo);
		}
		
		public function AddChild(bmp:Bitmap):void
		{
			_spriteSheetSprite.addChild(bmp);
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