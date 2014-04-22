package spriteSheet.image
{
	import flash.events.Event;
	
	public class ImageCustomEvent extends Event
	{
		private var _imageInfoVec:Vector.<ImageFileInfo>;
		
		public function ImageCustomEvent(type:String, imageInfoVec:Vector.<ImageFileInfo>, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_imageInfoVec = imageInfoVec;
		}
		
		public function get imageInfoVec():Vector.<ImageFileInfo>
		{
			return _imageInfoVec;
		}
	}
}