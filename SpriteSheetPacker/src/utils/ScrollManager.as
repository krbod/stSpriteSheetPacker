package utils
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class ScrollManager extends EventDispatcher
	{
		public static const GET_INTERVAL:String = "GET_INTERVAL";
		
		private var _beginX:Number, _beginY:Number;	
		
		private var _stage:Stage;
		private var _scrollingSprite:Sprite;
		
		/**
		 * 특정 Sprite 에 마우스 드래그 이벤트를 사용할 수 있도록 합니다. <br/>
		 * 드래그를 하면 움직인 x, y 변화량 Array를 포함하는 <br/>
		 *  ScrollManager.GET_INTERVAL Type의 ScrollEvent를 발생시킵니다.	
		 * @param stage 어플리케이션 Stage 객체
		 * @param sprite 드래그 이벤트를 사용할 Sprite 객체		  
		 */
		public function ScrollManager(stage:Stage, sprite:Sprite)
		{
			_stage = stage;
			_scrollingSprite = sprite;
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, BeginDrag);
		}
				
		private function BeginDrag(event:MouseEvent):void
		{			
			_beginX = _stage.mouseX-_scrollingSprite.x;
			_beginY = _stage.mouseY-_scrollingSprite.y;
			
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, BeginDrag);
			_stage.addEventListener(Event.ENTER_FRAME, OnDrag, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, EndDrag);			
		}
		
		private function OnDrag(event:Event):void 
		{			
			dispatchEvent(new ScrollEvent(
				GET_INTERVAL, 
				new Array(_stage.mouseX - _beginX, _stage.mouseY - _beginY)
			));
		}
		
		private function EndDrag(event:Event):void 
		{
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,BeginDrag);
			_stage.removeEventListener(Event.ENTER_FRAME,OnDrag);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,EndDrag);
		}
		
	}
}