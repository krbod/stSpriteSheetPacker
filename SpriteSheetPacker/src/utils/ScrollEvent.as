package utils
{
	import flash.events.Event;
	
	public class ScrollEvent extends Event
	{
		public static const GET_INTERVAL:String = "GET_INTERVAL";
		
		private var _interval:Array;
		
		public function ScrollEvent(type:String, interval:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_interval = interval;
		}
		
		public function get interval():Array
		{
			return _interval;
		}
	}
}