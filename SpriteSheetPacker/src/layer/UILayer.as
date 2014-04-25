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
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import utils.Resources;
	import utils.StatusManager;
	
	
	
	/**
	 * Boundary 버튼을 가지고 있는 Layer 
	 */
	public class UILayer extends Sprite
	{		
		// 경계 출력 버튼 위치
		private const BOUNDARY_BTN_POS_X:Number = 0.8;
		private const BOUNDARY_BTN_POS_Y:Number = 0.8;
		
		// 상태 텍스트 필드 위치
		private const STATUS_TXT_POS_X:Number = 0.1;
		private const STATUS_TXT_POS_Y:Number = 0.85;
		
		private var _boundaryButton:Sprite;
		private var _statusTextField:TextField = new TextField();
		
		public function UILayer()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		public function Init(event:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			// 경계 버튼 이미지를 로드
			InitBoundaryBtn();
			
			// 상태 텍스트 필드를 초기화
			InitStatusTextField();		
			
			// 상태 매니저에 텍스트 필드를 등록
			StatusManager.GetInstance().SetStatusTextField(_statusTextField);
		}
		
		public function set statusText(status:String):void
		{
			_statusTextField.text = status;
		}
		
		/**
		 * 경계 버튼 이미지를 로드합니다. 
		 */
		private function InitBoundaryBtn():void
		{			
			var loader:Loader = new Loader();
			var urlRequest:URLRequest = new URLRequest(Resources.IMAGE_BOUNDARY);
			loader.load(urlRequest);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnComplete);
			urlRequest = null;
			loader = null;
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
			
			bmp.x = stage.fullScreenWidth * BOUNDARY_BTN_POS_X;
			bmp.y = stage.fullScreenHeight * BOUNDARY_BTN_POS_Y;
			
			addChild(_boundaryButton);
		}
		
		private function InitStatusTextField():void
		{
			var format:TextFormat = new TextFormat(); 
			format.color = 0xffffff; 
			format.size = 32;
			
			_statusTextField.autoSize = TextFieldAutoSize.LEFT; 
			_statusTextField.antiAliasType = AntiAliasType.ADVANCED; 
			_statusTextField.defaultTextFormat = format; 
			_statusTextField.selectable = false; 
			_statusTextField.text = "Status Field"; 
			
			_statusTextField.background = true;
			_statusTextField.backgroundColor = 0x000000;
			
			_statusTextField.x = stage.fullScreenWidth * STATUS_TXT_POS_X;
			_statusTextField.y = stage.fullScreenHeight * STATUS_TXT_POS_Y;
						
			addChild(_statusTextField); 
			
			addEventListener(Event.ENTER_FRAME, UpdateStatusField);
		}
		
		private function UpdateStatusField(event:Event):void
		{
			_statusTextField.text = _statusTextField.text ;			
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