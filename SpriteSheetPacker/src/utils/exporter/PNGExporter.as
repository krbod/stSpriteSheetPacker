package utils.exporter
{
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	
	import spriteSheet.SpriteSheetInfo;
	import utils.Resources;

	/**
	 * com.adobe.images.PNGEncoder (as3corelib) 를 이용해 PNG 파일을 추출합니다.
	 * @see reference https://github.com/mikechambers/as3corelib
	 * 
	 */
	public class PNGExporter
	{
		
		/**
		 * 스프라이트 객체를 PNG 파일로 저장합니다. 
		 * @param sprite 스프라이트 이미지가 저장되어 있는 Sprite 오브젝트
		 * @return PNG 파일 생성 여부
		 */
		public function Export(spriteSheetInfo:SpriteSheetInfo):void
		{
			// 전체 스프라이트 시트 이미지가 담겨있는 Sprite 객체를 통해 BitmapData 를 추출
			var bitmapData:BitmapData = new BitmapData(spriteSheetInfo.width, spriteSheetInfo.height, true, 0x00FFFFFF);
			bitmapData.draw(spriteSheetInfo.spriteSheetImage);
			
			// BitmapData 를 PNG 로 인코딩
			var bytes:ByteArray = PNGEncoder.encode(bitmapData);
			
			
			// PNG 데이터가 있는 ByteArray 를 파일로 씀
			var file:File = File.desktopDirectory.resolvePath(Resources.EXPORT_PNG_FILE_PATH);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			
			fileStream.writeBytes(bytes);
						
			// 자원 해제
			fileStream.close();
			bitmapData.dispose();
			bytes.clear();
			
			file = null;
			fileStream = null;
		}
	}
}