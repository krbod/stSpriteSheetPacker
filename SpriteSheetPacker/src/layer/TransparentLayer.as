package layer
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TransparentLayer extends Sprite
	{
		// 배경 투명 블럭의 가로 세로 크기
		private const BACKGROUND_BLOCK_SIZE:int = 15;			
		
		public function TransparentLayer()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, DrawBackground);
		}
				
		/**
		 * PNG 이미지들의 투명 효과를 나타내기 위해 배경화면을 출력합니다.
		 */
		public function DrawBackground(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, DrawBackground);
			
			for(var y:uint = 0; y<stage.fullScreenHeight; y += BACKGROUND_BLOCK_SIZE )
			{
				for(var x:uint=0; x<stage.fullScreenWidth; x += BACKGROUND_BLOCK_SIZE)
				{
					// 짝수 번째 라인
					if( (y/BACKGROUND_BLOCK_SIZE)%2 == 0 ) 
					{
						if( (x/BACKGROUND_BLOCK_SIZE)%2 == 0 )
							this.graphics.beginFill(0xeeeeee);
						else
							this.graphics.beginFill(0xffffff);
					}
						// 홀수 번째 라인
					else
					{
						if( (x/BACKGROUND_BLOCK_SIZE)%2 == 0 )
							this.graphics.beginFill(0xffffff);
						else
							this.graphics.beginFill(0xeeeeee);
					}
					
					this.graphics.drawRect(x, y, BACKGROUND_BLOCK_SIZE, BACKGROUND_BLOCK_SIZE);
					this.graphics.endFill();
				}
			}
		}
	}
}