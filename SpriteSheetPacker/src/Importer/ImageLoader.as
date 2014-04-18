package Importer
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import Image.ImageCustomEvent;
	import Image.ImageInfo;

	public class ImageLoader extends EventDispatcher
	{
		public static const EVENT_LOAD_ALL:String = "All_IMAGE_LOADED";
		
		private const IMAGE_PATH:String = "in";
		
		private var _imageInfoVec:Vector.<ImageInfo>;
		
		private var _loader:Loader;
		private var _loadedImageCount:int;		
		private var _fileList:Array;
		
		public function ImageLoader()
		{
			_imageInfoVec = new Vector.<ImageInfo>;
			
			_loader  = new Loader();
			_loadedImageCount  = 0;
		}
		
		public function LoadImages():void
		{			
			var directory:File = File.applicationDirectory.resolvePath(IMAGE_PATH);					
			_fileList = directory.getDirectoryListing();
			
			LoadImagesRecursively();
		}
		
		private function LoadImagesRecursively():void
		{
			if( _loadedImageCount == _fileList.length-1 )
			{
				CleanObjects();
				
				dispatchEvent(new ImageCustomEvent(EVENT_LOAD_ALL, _imageInfoVec));
				return;
			}
			
			var imageInfo:ImageInfo = new ImageInfo();
			
			imageInfo.fileName = GetFileName(_fileList[_loadedImageCount].url);
			imageInfo.fileExtension = GetFileExtenstion(_fileList[_loadedImageCount].url);
			imageInfo.filePath = GetFilePath(_fileList[_loadedImageCount].url);	// relative path
			
			_imageInfoVec.push(imageInfo);
			
			GetBmpData(imageInfo.filePath);
			
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
		
		private function onComplete(e:Event):void
		{
			_imageInfoVec[_loadedImageCount].bmpData = Bitmap(LoaderInfo(e.target).content).bitmapData;
			
			++_loadedImageCount;
			LoadImagesRecursively();
		}
		
		private function CleanObjects():void
		{
			// clean the bitmap data
			var loaderDispose:LoaderInfo = _loader.contentLoaderInfo;
			if( loaderDispose.childAllowsParent && loaderDispose.content is Bitmap )
			{
				(loaderDispose.content as Bitmap).bitmapData.dispose();
			}
			
			// clean the loader
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loader.unload();
			_loader = null;
						
			// clean the file list 
			while(_fileList.length)
			{
				_fileList.pop();
			}	
		}

	}
}