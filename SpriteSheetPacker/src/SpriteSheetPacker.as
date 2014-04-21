package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import Exporter.PNGExporter;
	import Exporter.XMLExporter;
	
	import Image.ImageCustomEvent;
	
	import Importer.ImageLoader;
	
	import SpriteSheet.SpriteSheetInfo;
	import SpriteSheet.SpriteSheetMaker;
	
	
	public class SpriteSheetPacker extends Sprite
	{		
		public function SpriteSheetPacker()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// 폴더 내 이미지를 로드 
			var imageLoader:ImageLoader = new ImageLoader();
			imageLoader.LoadImages();			
			imageLoader.addEventListener( ImageLoader.EVENT_LOAD_ALL, onAllImageLoad ); 
		}
		
		public function onAllImageLoad(event:ImageCustomEvent):void
		{
			// 읽은 이미지 벡터를 이용해 스프라이트 시트 이미지 생성
			var spriteSheetMaker:SpriteSheetMaker = new SpriteSheetMaker();
			var sheetInfo:SpriteSheetInfo = spriteSheetMaker.MakeSpriteSheet(event.imageInfoVec);
			
			// XML 파일 추출
			var xmlExporter:XMLExporter = new XMLExporter();
			xmlExporter.Export(sheetInfo);
			
			// PNG 파일 추출
			var pngExporter:PNGExporter = new PNGExporter();
			pngExporter.Export(sheetInfo);
			
			// 스프라이트 시트 이미지 출력
			addChild(sheetInfo.spriteSheetImage);
		}
	}
}