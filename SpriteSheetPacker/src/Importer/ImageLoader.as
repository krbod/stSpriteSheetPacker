package Importer
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import Image.ImageCustomEvent;
	import Image.ImageFileInfo;

	/**
	 * 지정되어 있는 "in" 폴더 내부에 있는 이미지 파일을 읽어옵니다. <br/>
	 * 모든 이미지가 로드되면 "EVENT_LOAD_ALL" 이벤트를 발생시킵니다.
	 */
	public class ImageLoader extends EventDispatcher
	{
		public static const EVENT_LOAD_ALL:String = "All_IMAGE_LOADED";
		
		private const IMAGE_PATH:String = "in";
		
		private const IMAGE_BMP_EXTENSION:String = "bmp";
		private const IMAGE_JPG_EXTENSION:String = "jpg";
		private const IMAGE_PNG_EXTENSION:String = "png";
		
		private var _imageInfoVec:Vector.<ImageFileInfo>;
		
		private var _loader:Loader;
		private var _loadedImageCount:int;		
		private var _fileList:Array;
		
		public function ImageLoader()
		{
			_imageInfoVec = new Vector.<ImageFileInfo>;
			
			_loader  = new Loader();
			_loadedImageCount  = 0;
		}
		
		/**
		 * 폴더 내 모든 이미지 파일들을 읽음.
		 */
		public function LoadImages():void
		{			
			var directory:File = File.applicationDirectory.resolvePath(IMAGE_PATH);					
			_fileList = directory.getDirectoryListing();
			
			LoadImagesRecursively();
		}
		
		/**
		 * 	이벤트를 이용하여 파일을 읽음. <br/>
		 * 	하나의 파일을 다 읽으면 다시 함수를 호출하여 다른 이미지를 읽음
		 */
		private function LoadImagesRecursively():void
		{
			// 모든 파일을 다 읽었는 지 확인
			if( _loadedImageCount == _fileList.length )
			{
				CleanObjects();
				
				dispatchEvent(new ImageCustomEvent(EVENT_LOAD_ALL, _imageInfoVec));
				return;
			}
			
			// 이미지 파일인지 검사 (*.png, *.jpg, *.bmp)
			if( !IsImageFile(_fileList[_loadedImageCount].url) )		
			{				
				++_loadedImageCount;
				LoadImagesRecursively();
				
				return;
			}
			
			// 이미지 정보 저장
			var imageInfo:ImageFileInfo = new ImageFileInfo();
			
			imageInfo.fileName = GetFileName(_fileList[_loadedImageCount].url);
			imageInfo.fileExtension = GetFileExtenstion(_fileList[_loadedImageCount].url);
			imageInfo.filePath = GetFilePath(_fileList[_loadedImageCount].url);	// relative path
			
			_imageInfoVec.push(imageInfo);
			
			// 지원하지 않는 BMP 파일은 외부 library 사용 
			if(imageInfo.fileExtension == IMAGE_BMP_EXTENSION)
			{
				GetBmpDataFromBmpFile(_fileList[_loadedImageCount].url);
			}
			else
			{
				GetBmpData(imageInfo.filePath);
			}
			
		}
		
		private function GetFileName(filePath:String):String
		{			
			var startFileName:Number = filePath.lastIndexOf("\\");		// MAC
			if( startFileName < 0 )
				startFileName = filePath.lastIndexOf("/");							// Window, etc 
			
			return filePath.substring(startFileName+1, filePath.lastIndexOf("."));
		}
		
		private function GetFileExtenstion(filePath:String):String
		{
			return filePath.substring(filePath.lastIndexOf(".")+1, filePath.length);
		}
		
		private function GetFilePath(filePath:String):String
		{
			return IMAGE_PATH + "\\" + GetFileName(filePath) + "." + GetFileExtenstion(filePath);
		}
		
		private function GetBmpData(filePath:String):void
		{			
			var urlRequest:URLRequest = new URLRequest(filePath);
			_loader.load(urlRequest);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			urlRequest = null;
		}
		
		/**
		 * BMP 파일로 부터 bmpData 정보를 확인
		 * BMP 파일은 지원이 되지 않아서 외부 라이브러리 사용
		 * @param filePath
		 * @see reference http://stackoverflow.com/questions/2106195/loading-bmp-and-tiff-file-in-flash-10-using-loader
		 */
		private function GetBmpDataFromBmpFile(filePath:String):void
		{
			var file:File = new File(filePath);
			var fileStream:FileStream = new FileStream();			
			fileStream.open(file, FileMode.READ);
			
			var byteArray:ByteArray = new ByteArray();
			fileStream.readBytes(byteArray);
			
			fileStream.close();
			fileStream = null;
			file = null;
			
			var bmpDecoder:BMPDecoder = new BMPDecoder();			
			_imageInfoVec[_loadedImageCount].bmpData = bmpDecoder.decode(byteArray);
						
			bmpDecoder = null;
			byteArray = null;
			
			// 계속해서 폴더내 이미지들을 읽음
			++_loadedImageCount;
			LoadImagesRecursively();
		}
	
		private function onComplete(event:Event):void
		{
			_imageInfoVec[_loadedImageCount].bmpData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			
			++_loadedImageCount;
			LoadImagesRecursively();
		}
		
		/**
		 * 입력 파일이 이미지 파일(png, jpg, bmp)인지 확인
		 * @param filePath 파일 경로
		 * @return true : 이미지 일경우 false : 다른 파일 일 경우
		 * 
		 */
		private function IsImageFile(filePath:String):Boolean
		{
			var extension:String = GetFileExtenstion(filePath);
			if( 	extension == IMAGE_PNG_EXTENSION || 
					extension == IMAGE_BMP_EXTENSION || 
					extension == IMAGE_JPG_EXTENSION )
				return true
				
			return false;
		}
		
		private function CleanObjects():void
		{			
			// Loader 해제
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loader.unload();
			_loader = null;
						
			// 폴더 내 파일 정보 리스트 해제
			while(_fileList.length)
			{
				_fileList.pop();
			}	
		}

	}
}