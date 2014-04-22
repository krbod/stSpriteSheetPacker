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
		private var _isBoundaryButtonClicked:Boolean = false;
		
		private const BOUNDARY_BTN_POS_X:Number = 0.85;
		private const BOUNDARY_BTN_POS_Y:Number = 0.8;
		
		public function UILayer()
		{
			super();
			
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
			
			var boundaryButton:Sprite = new Sprite();
			boundaryButton.addChild(bmp);
			boundaryButton.buttonMode = true;
			boundaryButton.addEventListener(MouseEvent.CLICK, OnBoundaryClick);	
			
			boundaryButton.x = Resources.RESOLUTION_WIDTH * BOUNDARY_BTN_POS_X;
			boundaryButton.y = Resources.RESOLUTION_HEIGHT * BOUNDARY_BTN_POS_Y;
			
			addChild(boundaryButton);
		}
		
		/**
		 * Boundary 버튼을 클릭 했을 경우, Boundary 를 그리거나 지운다. 
		 */
		private function OnBoundaryClick(event:MouseEvent):void
		{
			var spriteSheetLayer:SpriteSheetLayer = SpriteSheetLayer(Sprite(this.parent).getChildByName(Resources.LAYER_NAME_SPRITE_SHEET));
			
			if( _isBoundaryButtonClicked == false )
				spriteSheetLayer.dispatchEvent(new Event(SpriteSheetLayer.EVENT_DRAW_ALL_BOUNDARY));
			else
				spriteSheetLayer.dispatchEvent(new Event(SpriteSheetLayer.EVENT_ERASE_ALL_BOUNDARY));
				
			_isBoundaryButtonClicked = !_isBoundaryButtonClicked;
		}
		
	}
}