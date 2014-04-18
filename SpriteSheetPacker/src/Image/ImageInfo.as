package Image
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class ImageInfo extends Sprite
	{		
		private var _fileName:String;
		private var _fileExtension:String;
		private var _filePath:String;
		
		private var _bmpData:BitmapData;		
		
		public function ImageInfo()
		{
			super();
		}

		public function Clean():void
		{
			_bmpData.dispose();
		}
		
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