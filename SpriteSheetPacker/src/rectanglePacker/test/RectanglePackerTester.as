package rectanglePacker.test
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import spriteSheet.rectanglePacker.RectanglePacker;
	import spriteSheet.rectanglePacker.stRect;
	
	public class RectanglePackerTester extends Sprite
	{
		public static const TEST_BLOCK_COUNT:int = 20;
		public static const TEST_BLOCK_MAX_SIZE:int = 100;
		
		public function RectanglePackerTester()
		{
			super();
						
			var rectanglePacker:RectanglePacker = new RectanglePacker();
			
			for(var i:int = 0; i<TEST_BLOCK_COUNT; ++i)
			{							
				DrawRect(rectanglePacker.InsertNewRect(getRandomRect()));
			}			
			
			rectanglePacker.Clear();
			rectanglePacker = null;
		}
		
		public function DrawRect(rect:stRect):void
		{
			var bmp:BitmapData = new BitmapData(rect.width, rect.height, false);
			bmp.fillRect(new Rectangle(0, 0, rect.width, rect.height), getRandomColor());
			
			var bitmap:Bitmap = new Bitmap(bmp);
			bitmap.x = rect.x;
			bitmap.y = rect.y;
			
			addChild(bitmap);	
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
	}
}