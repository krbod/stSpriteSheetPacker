
/**
 *  빌드 환경 :  Adobe AIR SDK 13.0, Window 7 64Bit
 *  Flash Builder 4.7 사용
 * 
 *  사용한 외부 라이브러리
 *  1. PNGEncoder : PNG 파일을 추출
 *     (ref : https://github.com/mikechambers/as3corelib)
 *  2. BMPDecoder : bmp파일로 부터 읽은 bytearray 를 통해 bmpData 를 추출
 *     (ref : http://stackoverflow.com/questions/2106195/loading-bmp-and-tiff-file-in-flash-10-using-loader) 
 */


package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import layer.SpriteSheetLayer;
	import layer.TransparentLayer;
	import layer.UILayer;
	
		
	public class SpriteSheetPacker extends Sprite
	{				
		private var _beginX:Number, _beginY:Number;		
		private var _spriteSheetLayer:SpriteSheetLayer;
		
		public function SpriteSheetPacker()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
						
			// 투명 효과를 나타낼 수 있는 배경 레이어 생성
			var transparentLayer:TransparentLayer = new TransparentLayer();
			addChild(transparentLayer);
			transparentLayer.DrawBackground();
			
			// 스프라이트 시트 이미지를 출력하는 레이어 생성
			_spriteSheetLayer = new SpriteSheetLayer();
			addChild(_spriteSheetLayer);			
			
			// UI 레이어 생성
			var uiLayer:UILayer = new UILayer();
			addChild(uiLayer);
						
			// 폴더 내에 있는 이미지를 불러와 스프라이트 이미지를 생성
			_spriteSheetLayer.LoadImages();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, BeginDrag);
		}		
		
		private function BeginDrag(event:MouseEvent):void
		{			
			_beginX = mouseX-_spriteSheetLayer.x;
			_beginY = mouseY-_spriteSheetLayer.y;
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, BeginDrag);
			addEventListener(Event.ENTER_FRAME, OnDrag, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, EndDrag);			
		}
		
		private function OnDrag(evt:Event):void 
		{			
			_spriteSheetLayer.x = mouseX - _beginX;
			_spriteSheetLayer.y = mouseY - _beginY;
		}
		
		private function EndDrag(evt:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN,BeginDrag);
			removeEventListener(Event.ENTER_FRAME,OnDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP,EndDrag);
		}
		
	}
}