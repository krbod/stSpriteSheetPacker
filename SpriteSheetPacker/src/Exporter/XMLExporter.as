package Exporter
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import SpriteSheet.SpriteInfo;
	import SpriteSheet.SpriteSheetInfo;

	public class XMLExporter
	{		
		// XML NODE NAME
		private const XML_ROOT_NODE:String = "sprite_sheet";
		private const XML_NODE:String = "sprite";
		private const XML_NODE_NAME:String = "name";
		private const XML_NODE_X:String = "x";
		private const XML_NODE_Y:String = "y";
		private const XML_NODE_WIDTH:String = "width";
		private const XML_NODE_HEIGHT:String = "height";
		private const XML_NODE_PATH:String = "path";
		
		/**
		 * XML 파일로 스프라이트 정보들을 추출합니다. 
		 * @param spriteSheetInfo 스프라이트 시트 정보 객체
		 */
		public function Export(spriteSheetInfo:SpriteSheetInfo):void
		{
			var spriteInfoVec:Vector.<SpriteInfo> = spriteSheetInfo.spritesVec;
			
			// 루트 노드 생성
			var rootNode:XML = XML(GetXMLNodeString(XML_ROOT_NODE, ""));
			
			// 스프라이트 노드 생성 및 루트 노드에 추가
			for(var i:uint = 0; i<spriteInfoVec.length; ++i)
			{
				var spriteNode:XML = XML(GetXMLNodeString( XML_NODE, ""));
				
				spriteNode.appendChild(XML(GetXMLNodeString( XML_NODE_NAME, spriteInfoVec[i].imageInfo.fileName )));
				
				spriteNode.appendChild(XML(GetXMLNodeString( XML_NODE_X, spriteInfoVec[i].x )));
				spriteNode.appendChild(XML(GetXMLNodeString( XML_NODE_Y, spriteInfoVec[i].y )));
				spriteNode.appendChild(XML(GetXMLNodeString( XML_NODE_WIDTH, spriteInfoVec[i].uvWidth )));
				spriteNode.appendChild(XML(GetXMLNodeString( XML_NODE_HEIGHT, spriteInfoVec[i].uvHeight )));
				spriteNode.appendChild(XML(GetXMLNodeString( XML_NODE_PATH, spriteInfoVec[i].imageInfo.filePath )));
				
				rootNode.appendChild(spriteNode);
			}
			
			// 파일에 XML 관련 데이터를 씀
			var file:File = File.desktopDirectory.resolvePath(Resources.EXPORT_XML_FILE_PATH);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			
			fileStream.writeUTFBytes(rootNode.toXMLString());
			fileStream.close();
		}
		
		/**
		 * 노드 이름과 값으로 XML String 을 생성 
		 * @param nodeName 생성할 노드의 이름
		 * @param value 생성할 노드의 값
		 * @return 생성한 XML String
		 */
		private function GetXMLNodeString(nodeName:String, value:String):String
		{
			return "<" + nodeName + ">" + value + "</" + nodeName + ">";
		}
			
	}
}