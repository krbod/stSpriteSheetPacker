package Exporter
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import SpriteSheet.SpriteInfo;

	public class XMLExporter
	{
		private const EXPORT_FILE_PATH:String = "out/spritesheet.xml";
		public function XMLExporter()
		{
		}
		
		public function Export(spriteInfoVec:Vector.<SpriteInfo>):Boolean
		{
			var root:String = "<sprite_sheet></sprite_sheet>";
	
			var rootNode:XML = XML(root);
			
			for(var i:uint = 0; i<spriteInfoVec.length; ++i)
			{
				
				var spriteString:String = "<sprite></sprite>";
				var spriteNode:XML = XML(spriteString);
				
				spriteNode.appendChild(XML("<name>" + spriteInfoVec[i].imageInfo.fileName + "</name>"));
				
				spriteNode.appendChild(XML("<x>" + spriteInfoVec[i].x + "</x>"));
				spriteNode.appendChild(XML("<y>" + spriteInfoVec[i].y + "</y>"));
				spriteNode.appendChild(XML("<width>" + spriteInfoVec[i].uvWidth + "</width>"));
				spriteNode.appendChild(XML("<height>" + spriteInfoVec[i].uvHeight + "</height>"));
				
				rootNode.appendChild(spriteNode);
			}
			
			var file:File = File.desktopDirectory.resolvePath(EXPORT_FILE_PATH);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			
			fileStream.writeUTFBytes(rootNode.toXMLString());
			
			return true;
		}
			
	}
}