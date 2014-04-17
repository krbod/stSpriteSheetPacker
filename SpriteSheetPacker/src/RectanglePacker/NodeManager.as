package RectanglePacker
{
	public class NodeManager
	{		
		/**
		 * Insert the new node to left or right of destNode 
		 * @param parentNode	will be the parent of new node
		 * @param newNode that will be added 
		 * @return "newNode" if succeeded to add or "null" if failed
		 * @see reference  http://www.blackpawn.com/texts/lightmaps/
		 */
		public function InsertNode(dstNode:Node, newNode:Node):Node
		{
			if( dstNode.left != null )
			{
//				var node:Node =InsertNode(dstNode.left, newNode);
//				if( node == null )
//					return InsertNode(dstNode.right, newNode);
//					
//				return node;
				
				return InsertNode(dstNode.left, newNode) || InsertNode(dstNode.right, newNode);
			}
			
			if( !dstNode.isEmpty )
				return null;
			
			switch( dstNode.rect.compare( newNode.rect ) )
			{
				case stRect.SAME:
					dstNode.isEmpty = false;
					return dstNode;
				
				case stRect.BIGGER:
					return null;
			}
			
			dstNode.left = new Node();
			dstNode.right = new Node();
			
			var dstRect:stRect = dstNode.rect;
			var newRect:stRect = newNode.rect;
			
			if( (dstRect.width - newRect.width) > ( dstRect.height - newRect.height ) )
			{
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, newRect.width, dstRect.height);
				dstNode.right.rect = new stRect(dstRect.x + newRect.width, dstRect.y, dstRect.width - newRect.width, dstRect.height);
			}
			else
			{
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, dstRect.width, newNode.rect.height);
				dstNode.right.rect = new stRect(dstRect.x, dstRect.y + newRect.height, dstRect.width, dstRect.height - newRect.height);
			}
			
			newNode = null;			
			return null;
		}
	}
}