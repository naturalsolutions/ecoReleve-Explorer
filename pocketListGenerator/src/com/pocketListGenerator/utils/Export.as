package com.pocketListGenerator.utils
{

	import flash.events.Event;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	public class Export
	{
		
		private static var strFormat:String="CSV";
		private static var strData:String="";
		
		public static function WriteData(str:String,format:String):void
		{
			strData=str;
			strFormat=format
			
			var file:File=new File();
			file.addEventListener(Event.SELECT,fileSelect);
			file.browseForSave("Save as...");
		}
		
		private static function fileSelect(event:Event):void
		{
			var strFilePath:String=event.target.nativePath;
			if (strFilePath.lastIndexOf(".")==-1){
				strFilePath	=strFilePath + "." + strFormat
			}		
			
			var myFile:File=File.desktopDirectory.resolvePath(strFilePath);
			var fileStream:FileStream=new FileStream();
			fileStream.open(myFile,FileMode.WRITE);
			
			try
			{
				fileStream.writeUTFBytes(strData);
			} catch(e:Error)
			{
				trace("Error on export");
				return;
			}
			
			fileStream.close();	
		}
		
	}
}