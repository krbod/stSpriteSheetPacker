package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import RectanglePacker.RectanglePackerTester;
	
	
	public class SpriteSheetPacker extends Sprite
	{
		public function SpriteSheetPacker()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var rectPackerTester:RectanglePackerTester = new RectanglePackerTester();
			addChild(rectPackerTester);
		}
	}
}