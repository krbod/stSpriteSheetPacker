package RectanglePacker
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class RectanglePackerTester extends Sprite
	{
		public static const TEST_BLOCK_COUNT:int = 20;
		public static const TEST_BLOCK_MAX_SIZE:int = 100;
		
		private var stageWidth:int = 500;
		private var stageHeight:int = 500;
		
		public function RectanglePackerTester()
		{
			super();
			
			var rootNode:Node = new Node();
			rootNode.rect = new stRect(0, 0, stageWidth, stageHeight);
			
			var nodeManager:NodeManager = new NodeManager();
			
			for(var i:int = 0; i<TEST_BLOCK_COUNT; ++i)
			{				
				var newNode:Node = new Node();
				newNode.rect = getRandomRect();
						
				DrawRect(nodeManager.InsertNode(rootNode, newNode));
			}
			
		}
		
		public function getRandomColor():Number
		{
			return Math.random() * 0xFFFFFF;
		}
		
		public function getRandomRect():stRect
		{
			return new stRect(
				0, 
				0, 
				Math.min(Math.floor(1+Math.random() * TEST_BLOCK_MAX_SIZE), TEST_BLOCK_MAX_SIZE),
				Math.min(Math.floor(1+Math.random() * TEST_BLOCK_MAX_SIZE), TEST_BLOCK_MAX_SIZE));
		}
		
		public function DrawRect(newNode:Node):void
		{
			var bmp:BitmapData = new BitmapData(newNode.rect.width, newNode.rect.height, false);
			bmp.fillRect(new Rectangle(0, 0, newNode.rect.width, newNode.rect.height), getRandomColor());
			
			var bitmap:Bitmap = new Bitmap(bmp);
			bitmap.x = newNode.rect.x;
			bitmap.y = newNode.rect.y;
			
			addChild(bitmap);	
		}
	}
}