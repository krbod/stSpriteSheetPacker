package layer
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import utils.exporter.PNGExporter;
	import utils.exporter.XMLExporter;
	
	import spriteSheet.image.ImageCustomEvent;
	import utils.importer.ImageLoader;
	
	import spriteSheet.SpriteSheetInfo;
	import spriteSheet.SpriteSheetMaker;
	import utils.Resources;
	
	public class SpriteSheetLayer extends Sprite
	{		
		// Boundary 출력 및 삭제 관련 이벤트
		public static const EVENT_DRAW_ALL_BOUNDARY:String = "EVENT_DRAW_ALL_BOUNDARY";
		public static const EVENT_ERASE_ALL_BOUNDARY:String = "EVENT_ERASE_ALL_BOUNDARY"
			
		private const BACKGROUND_BLOCK_SIZE:int = 15;
			
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
			imageLoader.LoadImages();			
			imageLoader.addEventListener( ImageLoader.EVENT_LOAD_ALL, OnAllImageLoad ); 		
			
			// 경계를 그리는 이벤트 리스너 설정
			addEventListener(EVENT_DRAW_ALL_BOUNDARY, OnDrawAllBoundary);
			addEventListener(EVENT_ERASE_ALL_BOUNDARY, OnEraseAllBoundary);
		}
		
		private function OnAllImageLoad(event:ImageCustomEvent):void
		{			
			// 읽은 이미지 벡터를 이용해 스프라이트 시트 이미지 생성
			var spriteSheetMaker:SpriteSheetMaker = new SpriteSheetMaker();
			_sheetInfo = spriteSheetMaker.MakeSpriteSheet(event.imageInfoVec);
			
			// 디바이스 해상도에 맞게 스케일 조정
			_sheetInfo.spriteSheetImage.scaleX = Resources.RESOLUTION_WIDTH/_sheetInfo.width;
			_sheetInfo.spriteSheetImage.scaleY = Resources.RESOLUTION_HEIGHT/_sheetInfo.height;
			
			// 뒷 배경을 그림 
			DrawBackground();
			
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
		 * PNG 이미지들의 투명 효과를 나타내기 위해 배경화면을 출력합니다.
		 */
		private function DrawBackground():void
		{
			for(var y:uint = 0; y<_sheetInfo.height; y += BACKGROUND_BLOCK_SIZE )
			{
				for(var x:uint=0; x<_sheetInfo.width; x += BACKGROUND_BLOCK_SIZE)
				{
					// 짝수 번째 라인
					if( (y/BACKGROUND_BLOCK_SIZE)%2 == 0 ) 
					{
						if( (x/BACKGROUND_BLOCK_SIZE)%2 == 0 )
							this.graphics.beginFill(0xeeeeee);
						else
							this.graphics.beginFill(0xffffff);
					}
					// 홀수 번째 라인
					else
					{
						if( (x/BACKGROUND_BLOCK_SIZE)%2 == 0 )
							this.graphics.beginFill(0xffffff);
						else
							this.graphics.beginFill(0xeeeeee);
					}
					
					this.graphics.drawRect(x, y, BACKGROUND_BLOCK_SIZE, BACKGROUND_BLOCK_SIZE);
					this.graphics.endFill();
				}
			}
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