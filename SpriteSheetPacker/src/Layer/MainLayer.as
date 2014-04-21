package Layer
{
	import flash.display.Sprite;
	
	import Exporter.PNGExporter;
	import Exporter.XMLExporter;
	
	import Image.ImageCustomEvent;
	
	import Importer.ImageLoader;
	
	import SpriteSheet.SpriteSheetInfo;
	import SpriteSheet.SpriteSheetMaker;
	
	public class MainLayer extends Sprite
	{
		private const RESOLUTION_WIDTH:int = 1024;
		private const RESOLUTION_HEIGHT:int = 768;
		
		public function MainLayer()
		{			
			// 폴더 내 이미지를 로드 
			var imageLoader:ImageLoader = new ImageLoader();
			imageLoader.LoadImages();			
			imageLoader.addEventListener( ImageLoader.EVENT_LOAD_ALL, OnAllImageLoad ); 
		}
		
		private function OnAllImageLoad(event:ImageCustomEvent):void
		{
			// 읽은 이미지 벡터를 이용해 스프라이트 시트 이미지 생성
			var spriteSheetMaker:SpriteSheetMaker = new SpriteSheetMaker();
			var sheetInfo:SpriteSheetInfo = spriteSheetMaker.MakeSpriteSheet(event.imageInfoVec);
			
			// 디바이스 해상도에 맞게 스케일 조정
			sheetInfo.spriteSheetImage.scaleX = RESOLUTION_WIDTH/sheetInfo.width;
			sheetInfo.spriteSheetImage.scaleY = RESOLUTION_HEIGHT/sheetInfo.height;
			
			// 스프라이트 시트 이미지 출력
			addChild(sheetInfo.spriteSheetImage);
			
			// XML 파일 추출
			var xmlExporter:XMLExporter = new XMLExporter();
			xmlExporter.Export(sheetInfo);
			
			// PNG 파일 추출
			var pngExporter:PNGExporter = new PNGExporter();
			pngExporter.Export(sheetInfo);
		}
	}
}