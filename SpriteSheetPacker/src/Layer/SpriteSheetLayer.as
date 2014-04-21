package Layer
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import Exporter.PNGExporter;
	import Exporter.XMLExporter;
	
	import Image.ImageCustomEvent;
	import Importer.ImageLoader;
	
	import SpriteSheet.SpriteSheetInfo;
	import SpriteSheet.SpriteSheetMaker;
	
	public class SpriteSheetLayer extends Sprite
	{		
		// Boundary 출력 및 삭제 관련 이벤트
		public static const EVENT_DRAW_ALL_BOUNDARY:String = "EVENT_DRAW_ALL_BOUNDARY";
		public static const EVENT_ERASE_ALL_BOUNDARY:String = "EVENT_ERASE_ALL_BOUNDARY"
			
		private var _sheetInfo:SpriteSheetInfo;
		
		public function SpriteSheetLayer()
		{			
			// 폴더 내 이미지를 로드 
			var imageLoader:ImageLoader = new ImageLoader();
			imageLoader.LoadImages();			
			imageLoader.addEventListener( ImageLoader.EVENT_LOAD_ALL, OnAllImageLoad ); 
			
			addEventListener(EVENT_DRAW_ALL_BOUNDARY, OnDrawAllBoundary);
			addEventListener(EVENT_ERASE_ALL_BOUNDARY, OnEraseAllBoundary);
		}
		
		public function GetTest():int
		{
			return 1;
		}
		
		private function OnAllImageLoad(event:ImageCustomEvent):void
		{
			// 읽은 이미지 벡터를 이용해 스프라이트 시트 이미지 생성
			var spriteSheetMaker:SpriteSheetMaker = new SpriteSheetMaker();
			_sheetInfo = spriteSheetMaker.MakeSpriteSheet(event.imageInfoVec);
			
			// 디바이스 해상도에 맞게 스케일 조정
			_sheetInfo.spriteSheetImage.scaleX = Resources.RESOLUTION_WIDTH/_sheetInfo.width;
			_sheetInfo.spriteSheetImage.scaleY = Resources.RESOLUTION_HEIGHT/_sheetInfo.height;
			
			// 스프라이트 시트 이미지 출력
			addChild(_sheetInfo.spriteSheetImage);
			
			// XML 파일 추출
			var xmlExporter:XMLExporter = new XMLExporter();
			xmlExporter.Export(_sheetInfo);
			
			// PNG 파일 추출
			var pngExporter:PNGExporter = new PNGExporter();
			pngExporter.Export(_sheetInfo);
		}
		
		
		/**
		 * 모든 이미지 주변에 경계를 그립니다.
		 */
		private function OnDrawAllBoundary(event:Event):void
		{
			_sheetInfo.DrawAllBoundary();
		}
		
		/**
		 * 스프라이트 시트 내에 있는 경계 라인을 지웁니다. 
		 */
		private function OnEraseAllBoundary(event:Event):void
		{
			_sheetInfo.EraseAllBoundary();			
		}
	}
}