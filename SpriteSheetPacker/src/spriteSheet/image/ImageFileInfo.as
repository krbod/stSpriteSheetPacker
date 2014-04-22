package spriteSheet.image
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * 불러온 이미지 파일에 대한 정보를 담고 있습니다.
	 * 파일 이름, 확장자, 경로 및 이미지 비트맵 데이터 정보를 포함합니다.
	 */
	public class ImageFileInfo extends Sprite
	{		
		private var _fileName:String;
		private var _fileExtension:String;
		private var _filePath:String;
		
		private var _bmpData:BitmapData;		
		
		public function ImageFileInfo()
		{
			super();
		}

		/**
		 * bmpData 자원 해제 
		 */
		public function Clear():void
		{
			_bmpData.dispose();
		}
				
		
		/** Property */
		
		public function get fileName():String
		{
			return _fileName;
		}
		public function set fileName(fileName:String):void
		{
			_fileName = fileName;	
		}
		
		public function get fileExtension():String
		{
			return _fileExtension;
		}
		public function set fileExtension(fileExtension:String):void
		{
			_fileExtension = fileExtension;
		}
		
		public function get filePath():String
		{
			return _filePath;
		}
		public function set filePath(filePath:String):void
		{
			_filePath = filePath;
		}
		
		public function get bmpData():BitmapData
		{
			return _bmpData;
		}
		public function set bmpData(bmpData:BitmapData):void
		{
			_bmpData = bmpData;
		}
		
		
	}
}