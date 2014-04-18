package RectanglePacker
{
	public class stRect
	{
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		
		private var _color:Number;
		
		public static const SAME:int = 0;
		public static const INTERSECT:int = 1;
		public static const BIGGER:int = 2;
		public static const SMALLER:int = 3;
				
		public function stRect(x:int = 0, y:int = 0, width:int = 0, height:int = 0)
		{
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}
		
		/**
		 * 
		 * @param rect 
		 * @return	SAME : rect is same with the parameter one
		 * 			 	SMALLER : parameter one is smaller
		 * 				BIGGER : parameter one is bigger
		 * 				INTERSECT : original rect is intersect with parameter one
		 */
		public function compare(rect:stRect):int
		{
			if( _width == rect.width && _height == rect.height )
			{
				return SAME;
			}
			else if( _width >= rect.width && _height >= rect.height )
			{
				return SMALLER;	
			}
			else if( _width <= rect.width && _height <= rect.height )
			{
				return BIGGER;
			}
			else
			{
				return INTERSECT;				
			}
		}
		
		/** property */
		
		public function get color():Number
		{
			return _color;
		}
		public function set color(color:Number):void
		{
			_color = color;
		}		
		
		public function get x():int
		{
			return _x;
		}
		public function set x(x:int):void
		{
			_x = x;
		}
		
		public function get y():int
		{
			return _y;
		}
		public function set y(y:int):void
		{
			_y = y;
		}
		
		public function get width():int
		{
			return _width;
		}
		public function set width(width:int):void
		{
			_width = width;
		}
		
		public function get height():int
		{
			return _height;
		}
		public function set height(height:int):void
		{
			_height = height;
		}
		
	}
}