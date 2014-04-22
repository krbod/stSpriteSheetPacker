package layer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import utils.Resources;
	
	
	/**
	 * Boundary 버튼을 가지고 있는 Layer 
	 */
	public class UILayer extends Sprite
	{		
		// 경계 출력 버튼 위치
		private const BOUNDARY_BTN_POS_X:Number = 0.85;
		private const BOUNDARY_BTN_POS_Y:Number = 0.8;
		
		private var _boundaryButton:Sprite;
		
		public function UILayer()
		{
			super();
			
			// 경계 버튼 이미지를 로드
			var loader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(Resources.IMAGE_BOUNDARY);
			loader.load(urlRequest);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnComplete);
			urlRequest = null;
		}
		
		/**
		 * Boundary 버튼 이미지 로드 후에 버튼을 출력함
		 */
		private function OnComplete(event:Event):void
		{
			var bmpData:BitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			var bmp:Bitmap = new Bitmap(bmpData);
			
			_boundaryButton = new Sprite();
			_boundaryButton.addChild(bmp);
			_boundaryButton.buttonMode = true;
			_boundaryButton.addEventListener(MouseEvent.CLICK, OnBoundaryClick);	
			
			_boundaryButton.x = Resources.RESOLUTION_WIDTH * BOUNDARY_BTN_POS_X;
			_boundaryButton.y = Resources.RESOLUTION_HEIGHT * BOUNDARY_BTN_POS_Y;
			
			addChild(_boundaryButton);
		}
		
		/**
		 * Boundary 버튼을 클릭 했을 경우, Boundary 를 그리거나 지운다. 
		 */
		private function OnBoundaryClick(event:MouseEvent):void
		{
			var spriteSheetLayer:SpriteSheetLayer = SpriteSheetLayer(Sprite(this.parent).getChildByName(Resources.LAYER_NAME_SPRITE_SHEET));
			
			spriteSheetLayer.dispatchEvent(new Event(SpriteSheetLayer.EVENT_HANDLE_BOUNDARY));
		}
		
		/**
		 * 사용한 자원 해제 
		 */
		public function Clear():void
		{
			if( _boundaryButton != null )
			{
				var bmp:Bitmap = Bitmap(_boundaryButton.getChildAt(0));
				bmp.bitmapData.dispose();
				bmp = null;
				
				_boundaryButton = null;
			}
		}
		
	}
}