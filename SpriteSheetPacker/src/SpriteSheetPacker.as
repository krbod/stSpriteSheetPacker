
/**
 *  빌드 환경 :  Adobe AIR SDK 13.0, Window 7
 *  Flash Builder 4.7 사용
 * 
 *  사용한 외부 라이브러리
 *  1. com.adobe.images.PNGEncoder : PNG 파일을 추출
 *     (ref : https://github.com/mikechambers/as3corelib)
 *  2. BMPDecoder bmp파일로 부터 읽은 bytearray 를 통해 bmpData 를 추출
 *     (ref : http://stackoverflow.com/questions/2106195/loading-bmp-and-tiff-file-in-flash-10-using-loader) 
 */


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
		private const RESOLUTION_WIDTH:int = 1024;
		private const RESOLUTION_HEIGHT:int = 768;
		
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