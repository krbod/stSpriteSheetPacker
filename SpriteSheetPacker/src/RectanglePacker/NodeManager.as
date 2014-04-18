package RectanglePacker
{
	public class NodeManager
	{		
		/**
		 * Insert the new rectacgle information to left or right of destNode 
		 * @param dstNode	will be the parent of new node
		 * @param newRect that will be added 
		 * @return "newRect" if succeeded to add or "null" if failed
		 * @see reference  http://www.blackpawn.com/texts/lightmaps/
		 */
		public function InsertNewRect(dstNode:Node, newRect:stRect):Node
		{
			if( dstNode.left != null )
			{				
				return InsertNewRect(dstNode.left, newRect) || InsertNewRect(dstNode.right, newRect);
			}
			
			if( !dstNode.isEmpty )
				return null;
			
			switch( dstNode.rect.compare( newRect ) )
			{
				case stRect.SAME:
					dstNode.isEmpty = false;														
					return dstNode;
					
				case stRect.BIGGER:
				case stRect.INTERSECT:
					return null;
			}
			
			dstNode.left = new Node();
			dstNode.right = new Node();
			
			var dstRect:stRect = dstNode.rect;
			
			if( (dstRect.width - newRect.width) > ( dstRect.height - newRect.height ) )
			{
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, newRect.width, dstRect.height);
				dstNode.right.rect = new stRect(dstRect.x + newRect.width, dstRect.y, dstRect.width - newRect.width, dstRect.height);
			}
			else
			{
				dstNode.left.rect = new stRect(dstRect.x, dstRect.y, dstRect.width, newRect.height);
				dstNode.right.rect = new stRect(dstRect.x, dstRect.y + newRect.height, dstRect.width, dstRect.height - newRect.height);
			}
			
			return InsertNewRect(dstNode.left, newRect);			
		}
		
	}
}