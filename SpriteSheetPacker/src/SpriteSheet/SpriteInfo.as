package SpriteSheet
{
	import Image.ImageFileInfo;

	/**
	 * 스프라이트 시트에 저장될 각각의 이미지 정보를 저장
	 */
	public class SpriteInfo
	{
		private var _x:int, _y:int;
		private var _uvWidth:Number, _uvHeight:Number;
		private var _imageInfo:ImageFileInfo;
		
		public function SpriteInfo(x:int, y:int, w:Number, h:Number, imageInfo:ImageFileInfo)
		{
			_x = x;
			_y = y;
			_uvWidth = w;
			_uvHeight = h;
			_imageInfo = imageInfo;
		}
		
		public function get x():int
		{
			return _x;
		}
		public function set x(x:int):void
		{
			_x = x;
		}
		
		public function get y():int
		{
			return _y;
		}
		public function set y(y:int):void
		{
			_y = y;
		}
		
		public function get uvWidth():Number
		{
			return _uvWidth;
		}
		public function set uvWidth(uvWidth):void
		{
			_uvWidth = uvWidth;
		}
		
		public function get uvHeight():Number
		{
			return _uvHeight;
		}
		public function set uvHeight(uvHeight):void
		{
			_uvHeight = uvHeight;
		}
		
		public function get imageInfo():ImageFileInfo
		{
			return _imageInfo;
		}
		public function set imageInfo(imageInfo:ImageFileInfo):void
		{
			_imageInfo = imageInfo;
		}
	}
}