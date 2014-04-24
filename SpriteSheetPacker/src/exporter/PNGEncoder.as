/*
Copyright (c) 2008, Adobe Systems Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.

* Neither the name of Adobe Systems Incorporated nor the names of its 
contributors may be used to endorse or promote products derived from 
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package exporter
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import utils.StatusManager;
	
	/**
	 * Class that converts BitmapData into a valid PNG
	 */	
	public class PNGEncoder extends Sprite
	{
		private static const END_OF_ENCODING:String = "END_OF_ENCODING";
		
		private var _png:ByteArray = new ByteArray();
		private var _IHDR:ByteArray = new ByteArray();
		private var _IDAT:ByteArray= new ByteArray();
		private var _img:BitmapData;
		private var _frameTime:int = 20;
		
		private var _lastRow:uint = 0;
		
		private var _callback:Function; 
		
		public function PNGEncoder(callback:Function)
		{
			_callback = callback;
		}
		
		/**
		 * Created a PNG image from the specified BitmapData
		 *
		 * @param image The BitmapData that will be converted into the PNG format.
		 * @return a ByteArray representing the PNG encoded image data.
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */			
		public function encode(img:BitmapData):void 
		{			
			// Write PNG signature
			_png.writeUnsignedInt(0x89504e47);
			_png.writeUnsignedInt(0x0D0A1A0A);
			
			// Build IHDR chunk
			_IHDR.writeInt(img.width);
			_IHDR.writeInt(img.height);
			_IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
			_IHDR.writeByte(0);
			writeChunk(_png,0x49484452,_IHDR);
			
			// Build IDAT chunk
		    _img = img;
			
			// 비동기로 PNG 파일을 인코딩
			addEventListener(Event.ENTER_FRAME, FrameHandler);			
			addEventListener(END_OF_ENCODING, EncodeTail);
			
		}
		
		/**
		 * 비동기적으로 PNG 파일을 인코딩하기 위해 콜백으로 불려지는 함수 
		 */
		private function FrameHandler(event:Event):void
		{
			var isComplete:Boolean = false;
			var endTime:uint = getTimer() + _frameTime;
			
			while( !isComplete && endTime > getTimer() )
			{
				var i:uint = _lastRow;
				StatusManager.GetInstance().SetStatus("[PNG Encoding] " + ( i / _img.height * 100).toFixed(2) + "%"); 
				
				// no filter
				_IDAT.writeByte(0);
				var p:uint;
				var j:int;
				
				if ( !_img.transparent ) 
				{
					for(j=0;j < _img.width;j++) 
					{
						p = _img.getPixel(j,i);
						_IDAT.writeUnsignedInt( uint( ((p&0xFFFFFF) << 8) | 0xFF));
					}
				} 
				else 
				{
					for(j=0;j < _img.width;j++) 
					{
						p = _img.getPixel32(j,i);
						_IDAT.writeUnsignedInt( uint( ((p&0xFFFFFF) << 8) | 	(p>>>24)));
					}
				}
				
				if( i == _img.height -1 )
					isComplete = true;
				
				i++;
				_lastRow = i;
			}
			
			if( isComplete )
			{
				StatusManager.GetInstance().SetStatus("[PNG Encoding] 100%"); 
				
				dispatchEvent(new Event(END_OF_ENCODING));
				
				removeEventListener(Event.ENTER_FRAME, FrameHandler);
				removeEventListener(END_OF_ENCODING, EncodeTail);
			}
		}
		
		private function EncodeTail(event:Event):void
		{			
			StatusManager.GetInstance().visible = false;
			
			_IDAT.compress();
			
			writeChunk(_png,0x49444154,_IDAT);
			
			// Build IEND chunk
			writeChunk(_png,0x49454E44,null);
			
			_callback(_png);
			
			_IHDR.clear();
			_IHDR = null;
			_IDAT.clear();
			_IDAT = null;
		}
		
		private var crcTable:Array;
		private var crcTableComputed:Boolean = false;
		
		private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void 
		{
			if (!crcTableComputed) 
			{
				crcTableComputed = true;
				crcTable = [];
				var c:uint;
				for (var n:uint = 0; n < 256; n++) 
				{
					c = n;
					for (var k:uint = 0; k < 8; k++) 
					{
						if (c & 1) 
						{
							c = uint(uint(0xedb88320) ^ uint(c >>> 1));
						} 
						else 
						{
							c = uint(c >>> 1);
						}
					}
					crcTable[n] = c;
				}
			}
			
			var len:uint = 0;
			if (data != null) 
			{
				len = data.length;
			}
			
			png.writeUnsignedInt(len);
			var p:uint = png.position;
			png.writeUnsignedInt(type);
			
			if ( data != null ) 
			{
				png.writeBytes(data);
			}
			
			var e:uint = png.position;
			png.position = p;
			c = 0xffffffff;
			
			for (var i:int = 0; i < (e-p); i++) 
			{
				c = uint(crcTable[
					(c ^ png.readUnsignedByte()) & 
					uint(0xff)] ^ uint(c >>> 8));
			}
			
			c = uint(c^uint(0xffffffff));
			png.position = e;
			png.writeUnsignedInt(c);
		}
	}
}