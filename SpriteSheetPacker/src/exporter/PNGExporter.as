package exporter
{
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
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
		private var _bitmapData:BitmapData;
		
		/**
		 * 스프라이트 객체를 PNG 파일로 저장합니다. 
		 * @param sprite 스프라이트 이미지가 저장되어 있는 Sprite 오브젝트
		 * @return PNG 파일 생성 여부
		 */
		public function Export(spriteSheetInfo:SpriteSheetInfo):void
		{
			// 전체 스프라이트 시트 이미지가 담겨있는 Sprite 객체를 통해 BitmapData 를 추출
			_bitmapData = new BitmapData(spriteSheetInfo.width, spriteSheetInfo.height, true, 0x00FFFFFF);
			_bitmapData.draw(spriteSheetInfo.spriteSheetImage);
			
			// BitmapData 를 PNG 로 비동기식으로 인코딩
			var pngEncoder:PNGEncoder = new PNGEncoder(CompleteEncodingPNG);
			pngEncoder.encode(_bitmapData);

		}
		
		/**
		 * PNG 파일 인코딩이 끝났을 경우 콜백으로 불려지는 함수입니다. 
		 * @param png 인코딩이 끝난 byte array
		 */
		private function CompleteEncodingPNG(png:ByteArray):void
		{									
			// PNG 데이터가 있는 ByteArray 를 파일로 씀
			var destString:String;
			if( Capabilities.os.toLowerCase().indexOf("win") >= 0 )
			{
				destString = File.applicationDirectory.resolvePath(Resources.EXPORT_PNG_FILE_PATH).nativePath;
			}
			else
			{
				destString = File.applicationStorageDirectory.resolvePath(Resources.EXPORT_PNG_FILE_PATH).nativePath;
			}
			
			var destFile:File = new File( destString );
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(destFile, FileMode.WRITE);
			
			fileStream.writeBytes(png);
						
			// 자원 해제
			fileStream.close();
			_bitmapData.dispose();
			png.clear();
			
			destFile = null;
			fileStream = null;
		}
	}
}