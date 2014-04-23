package rectanglePacker
{
	public class Node
	{
		private var _left:Node;
		private var _right:Node;
		private var _rect:stRect;
		private var _isEmpty:Boolean;
		
		public function Node()
		{
			_left = null;
			_right = null;
			_rect = new stRect();
			_isEmpty = true;
		}
		
		public function Clear():void{
			
			if( _left != null )
			{
				_left.Clear();
				_left = null;
			}
			if( _right != null )
			{
				_right.Clear();
				_right = null;
			}
			
			_rect = null;
		}
		
		public function get left():Node
		{
			return _left;
		}
		public function set left(left:Node):void
		{
			_left = left;
		}
		
		public function get right():Node
		{
			return _right;
		}
		public function set right(right:Node):void
		{
			_right = right;
		}
		
		public function get isEmpty():Boolean
		{
			return _isEmpty;
		}
		public function set isEmpty(isEmpty:Boolean):void
		{
			_isEmpty = isEmpty;
		}
		
		public function get rect():stRect
		{
			return _rect;
		}
		public function set rect(rect:stRect):void
		{
			_rect = rect;
		}
		
		
	}
}