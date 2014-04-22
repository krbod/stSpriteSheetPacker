
/**
 *  빌드 환경 :  Adobe AIR SDK 13.0, Window 7
 *  Flash Builder 4.7 사용
 * 
 *  사용한 외부 라이브러리
 *  1. PNGEncoder : PNG 파일을 추출
 *     (ref : https://github.com/mikechambers/as3corelib)
 *  2. BMPDecoder : bmp파일로 부터 읽은 bytearray 를 통해 bmpData 를 추출
 *     (ref : http://stackoverflow.com/questions/2106195/loading-bmp-and-tiff-file-in-flash-10-using-loader) 
 */


package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import layer.SpriteSheetLayer;
	import layer.UILayer;
	
	import utils.Resources;
	
		
	public class SpriteSheetPacker extends Sprite
	{		
		public function SpriteSheetPacker()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var spriteSheetLayer:SpriteSheetLayer = new SpriteSheetLayer();
			spriteSheetLayer.name = Resources.LAYER_NAME_SPRITE_SHEET;
			addChild(spriteSheetLayer);			
			
			var uiLayer:UILayer = new UILayer();
			addChild(uiLayer);
						
		}		
		
	}
}