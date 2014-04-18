package RectanglePacker
{
	public class RectanglePacker
	{		
		private var _rootNode:Node;	// Packing 알고리즘 최 상위 루트 노드
		
		public function RectanglePacker(stageWidth:int, stageHeight:int)
		{			
			_rootNode = new Node();
			_rootNode.rect = new stRect(0, 0, stageWidth, stageHeight);
		}
		
		/**
		 * 새로운 Rectangle 을 Packer 알고리즘 트리에 추가합니다.
		 * @param newRect 추가할 Rectangle
		 * @return 추가된 Rectangle 의 위치 및 길이 정보가 담긴 Rectangle
		 * 
		 */
		public function InsertNewRect(newRect:stRect):stRect
		{
			return AddRectToTree(_rootNode, newRect);
		}
		
		/**
		 * 새로운 Rectangle 정보를 트리에 추가합니다.
		 * @param dstNode 추가할 새로운 노드의 타겟
		 * @param newRect 새로운 Rectangle 정보
		 * @return 성공: 추가된 Rectangle의 위치과 길이 정보가 담긴 Rectangle <br/> 실패: null
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
			
			// 새로운 Rectangle 의 세로가 더 긴경우에는 공간을 수직으로 구분
			if( (dstRect.width - newRect.width) > ( dstRect.height - newRect.height ) )
			{
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, newRect.width, dstRect.height);
				dstNode.right.rect = new stRect(dstRect.x + newRect.width, dstRect.y, dstRect.width - newRect.width, dstRect.height);
			}
			// 가로로 더 긴 Rectangle 의 경우에는 공간을 좌우로 구분
			else
			{
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, dstRect.width, newRect.height);
				dstNode.right.rect = new stRect(dstRect.x, dstRect.y + newRect.height, dstRect.width, dstRect.height - newRect.height);
			}
			
			// 구분된 공간에서 왼쪽 공간(좌우로 구분하였으면 위쪽)으로 다시 확인 
			return AddRectToTree(dstNode.left, newRect);
		}
		
		/**
		 * 알고리즘에 사용한 트리 해제
		 */
		public function Clean():void
		{
			_rootNode.Clean();
		}
		
	}
}