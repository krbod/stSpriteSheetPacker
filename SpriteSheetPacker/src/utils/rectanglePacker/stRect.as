package utils.rectanglePacker
{
	/**
	 * 새롭게 정의한 Rectangle 객체 
	 */
	public class stRect
	{
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		
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
		 * 2개의 stRect 객체의 위치 및 크기를 비교합니다.
		 * @param rect 비교할 stRect 객체
		 * @return	SAME : 서로의 stRect 위치와 크기가 일치한 경우<br/>
		 * 			 	SMALLER : 파라미터 stRect 가 더 작은 경우<br/>
		 * 				BIGGER : 파라미터 stRect 가 더 큰 경우<br/>
		 * 				INTERSECT : 서로 교차하는 경우<br/>
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