package rectanglePacker
{
	public class RectanglePacker
	{	
		private var _rootNode:Node;	// Packing 알고리즘 최 상위 루트 노드
		
		private const INITIAL_SIZE:int = 32;
		
		private var _canvasWidth:int = INITIAL_SIZE;
		private var _canvasHeight:int = INITIAL_SIZE;
		
		private var _spacing:int;
		
		public function RectanglePacker(spacing:int = 0)
		{			
			_rootNode = new Node();
			_rootNode.rect = new stRect(0, 0, _canvasWidth, _canvasHeight);
			
			_spacing = spacing;
		}
		
		/**
		 * 새로운 Rectangle 을 Packer 알고리즘 트리에 추가합니다.
		 * @param newRect 추가할 Rectangle
		 * @return 추가된 Rectangle 의 위치 및 길이 정보가 담긴 Rectangle
		 * 
		 */
		public function InsertNewRect(newRect:stRect):stRect
		{			
			newRect.width += _spacing * 2;	// 이미지 좌측 spacing, 우측 spacing -> *2
			newRect.height += _spacing * 2;	// 이미지 상단 spacing, 하단 spacing -> *2
			
			return AddRectToTree(_rootNode, newRect);
		}
		
		/**
		 * 새로운 Rectangle 정보를 트리에 추가합니다. <br/>
		 * <i>( Lightmap 알고리즘 수정 : 새로운 Rect 가 맨 좌측으로 들어갈 경우에 구분선은 항상 수평 )</i>
		 * @param dstNode 추가할 새로운 노드의 타겟
		 * @param newRect 새로운 Rectangle 정보
		 * @return stRect 객체 : 성공시, 추가된 Rectangle의 위치과 길이 정보를 포함) <br/>  null : 실패시
		 * @see reference  http://www.blackpawn.com/texts/lightmaps/
		 */
		private function AddRectToTree(dstNode:Node, newRect:stRect):stRect
		{			
			// 왼쪽 자식이 있는 지 확인하고 없으면 왼쪽으로  먼저 진행
			if( dstNode.left != null )
			{				
				// 왼쪽에 새로운 Rectangle 을 넣을 수 없으면 오른쪽을 확인
				return AddRectToTree(dstNode.left, newRect) || AddRectToTree(dstNode.right, newRect);
			}
			
			// 이미 다른 Rectangle 이 저장되어 있으면 return null
			if( !dstNode.isEmpty )
				return null;
			
			// 새로운 Rectangle 이 dstNode.rect 에 들어갈 수 있는 지 확인
			switch( dstNode.rect.compare( newRect ) )
			{
				case stRect.SAME:
					dstNode.isEmpty = false;														
					return dstNode.rect;
					
				case stRect.BIGGER:
				case stRect.INTERSECT:
					return null;
			}
			
			// 들어 갈수 있으면 새로운 자식들을 생성
			dstNode.left = new Node();
			dstNode.right = new Node();
			
			var dstRect:stRect = dstNode.rect;
			
			// 새로운 Rectangle(newRect)과 들어갈 공간(dstRect)을 비교해서 남은 우측 여백과 하단 여백의 차이를 비교해 우측 여백이 더 짧거나 서로 같을 경우에는 구분선을 수평으로 둠
			// 또는, 전체 캔버스에서 맨 좌측에 처음으로 들어갈 경우에는 무조건 구분선을 수평으로 둠 (기존 Lightmap 알고리즘에서 추가한 부분 )
			if( (dstRect.height - newRect.height ) >= (dstRect.width - newRect.width)  || (dstRect.width == _canvasWidth && newRect.height != dstRect.height ) )  
			{				
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, dstRect.width, newRect.height);
				dstNode.right.rect = new stRect(dstRect.x, dstRect.y + newRect.height, dstRect.width, dstRect.height - newRect.height);
			}
			// 가로로 더 긴 경우에는 공간에 구분선을 수직으로 둠
			else
			{
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, newRect.width, dstRect.height);
				dstNode.right.rect = new stRect(dstRect.x + newRect.width, dstRect.y, dstRect.width - newRect.width, dstRect.height);				
			}
			
			// 구분된 공간에서 왼쪽 공간(좌우로 구분하였으면 위쪽)으로 다시 확인 
			return AddRectToTree(dstNode.left, newRect);
		}
		
		/**
		 * 삽입되는 Rect 들의 크기가 기존의 캔버스 크기를 넘을 경우 <br/>  
		 * 기존 캔버스 크기를 늘립니다.
		 */
		public function Resize():void
		{
			_rootNode.Clear();
			
			if( _canvasWidth >= _canvasHeight )
			{
				_canvasHeight *= 2;
			}
			else
			{
				_canvasWidth *= 2;
			}
			
			_rootNode = new Node();
			_rootNode.rect = new stRect(0, 0, _canvasWidth, _canvasHeight);
		}
		
		/**
		 * 알고리즘에 사용한 트리 해제
		 */
		public function Clear():void
		{
			_rootNode.Clear();
			_rootNode = null;
		}
		
		
		
		/** Property */
		
		public function get spriteWidth():int
		{
			return _canvasWidth;
		}
		public function get spriteHeight():int
		{
			return _canvasHeight;
		}
		
	}
}