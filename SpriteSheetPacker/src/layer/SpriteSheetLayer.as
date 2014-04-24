package layer
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import exporter.PNGExporter;
	import exporter.XMLExporter;
	
	import importer.ImageLoader;
	
	import spriteSheet.SpriteSheetInfo;
	import spriteSheet.SpriteSheetMaker;
	import spriteSheet.image.ImageCustomEvent;
	
	import utils.Resources;
	import utils.ScrollEvent;
	import utils.ScrollManager;
	
	public class SpriteSheetLayer extends Sprite
	{		
		// Boundary 출력 및 삭제 관련 이벤트
		public static const EVENT_HANDLE_BOUNDARY:String = "EVENT_HANDLE_BOUNDARY";
				
		private var _sheetInfo:SpriteSheetInfo;		

		public function SpriteSheetLayer()
		{			
			this.name = Resources.LAYER_NAME_SPRITE_SHEET;
		}
				
		/**
		 * 폴더 내 이미지를 로드하고 스프라이트 시트를 만든후 출력합니다.<br/> 
		 * 출력후에는 atlas.xml 과 spritesheet.png 파일을 생성합니다. 
		 */
		public function LoadImages():void
		{			
			// 폴더 내 이미지를 로드 
			var imageLoader:ImageLoader = new ImageLoader();
			imageLoader.addEventListener( ImageLoader.EVENT_LOAD_ALL, OnAllImageLoad ); 	
			
			imageLoader.LoadImages();				
			
			// 경계를 그리는 이벤트 리스너 설정
			addEventListener(EVENT_HANDLE_BOUNDARY, OnDrawAllBoundary);
		}
		
		/**
		 * 스프라이트를 스크롤할 수 있도록 합니다. 
		 */
		public function AddScrollListener():void
		{
			var scrollManager:ScrollManager = new ScrollManager(this);
			scrollManager.addEventListener(ScrollEvent.GET_INTERVAL, OnScrollSprite);
		}

		/**
		 * 사용한 자원을 해제 합니다. 
		 */
		public function Clear():void
		{
			if( _sheetInfo != null )
			{
				_sheetInfo.Clear();
				_sheetInfo = null;
			}
		}
				
		/**
		 * 스크롤 이벤트 결과를 받아 Sprite Sheet Layer 를 이동시킵니다. 
		 * @param event 마우스 드래그 변화량이 들어있는 이벤트 객체
		 */
		private function OnScrollSprite(event:ScrollEvent):void{
			// 스프라이트 이미지 크기를 넘어서 스크롤을 할 경우에는 안 움직이도록 함
			if( event.interval[0] > 0 )
				event.interval[0] = 0;
			if( event.interval[1] > 0 )
				event.interval[1] = 0;
			
			if( (event.interval[0] * -1 + stage.fullScreenWidth) > _sheetInfo.width )
				event.interval[0] = (_sheetInfo.width - stage.fullScreenWidth) * -1;				
			if( (event.interval[1] * -1 + stage.fullScreenHeight ) > _sheetInfo.height )
				event.interval[1] = (_sheetInfo.height - stage.fullScreenHeight ) * -1;
					
			// 스프라이트를 옮김
			this.x = event.interval[0];
			this.y = event.interval[1];			
		}
			
		private function OnAllImageLoad(event:ImageCustomEvent):void
		{			
			// 읽은 이미지 벡터를 이용해 스프라이트 시트 이미지 생성
			var spriteSheetMaker:SpriteSheetMaker = new SpriteSheetMaker();
			_sheetInfo = spriteSheetMaker.MakeSpriteSheet(event.imageInfoVec);
						
			// 스프라이트 시트 이미지 출력
			addChild(_sheetInfo.spriteSheetImage);
			
			// XML 파일 추출
			var xmlExporter:XMLExporter = new XMLExporter();
			xmlExporter.Export(_sheetInfo);
			
			// PNG 파일 추출
			var pngExporter:PNGExporter = new PNGExporter();
			pngExporter.Export(_sheetInfo);
			
			// 사용한 자원 해제
			spriteSheetMaker = null;
			xmlExporter = null;
			pngExporter = null;
		}

		
		/**
		 * 모든 이미지 주변에 경계를 그립니다.
		 */
		private function OnDrawAllBoundary(event:Event):void
		{
			_sheetInfo.DrawAllBoundary();
			
			// 이벤트 리스너 함수 변경			
			removeEventListener(EVENT_HANDLE_BOUNDARY, OnDrawAllBoundary);
			addEventListener(EVENT_HANDLE_BOUNDARY, OnEraseAllBoundary);
		}
		
		/**
		 * 스프라이트 시트 내에 있는 경계 라인을 지웁니다. 
		 */
		private function OnEraseAllBoundary(event:Event):void
		{
			_sheetInfo.EraseAllBoundary();		
			
			// 이벤트 리스너 함수 변경
			removeEventListener(EVENT_HANDLE_BOUNDARY, OnEraseAllBoundary);
			addEventListener(EVENT_HANDLE_BOUNDARY, OnDrawAllBoundary);
		}
	}
}