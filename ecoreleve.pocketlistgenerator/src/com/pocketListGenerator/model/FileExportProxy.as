package com.importCSV.model.VO
{
	import com.pocketListGenerator.view.ApplicationFacade;
	
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.*;
	import flash.utils.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class FileExportProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "FileExportProxy";
		
		public static const FORMAT:String = "csv";
		
		public var f:File;
		
		public function FileExportProxy()
		{
			super( NAME );			
		}
		
		public function exportCSV():void
		{
			f = new File();
			
			f.addEventListener( Event.CANCEL, cancelHandler );
			f.addEventListener( Event.SELECT, selectHandler );
			
			try
			{
				f.browseForSave("Save as...");
			}
			catch (illegalOperation:IllegalOperationError )
			{
				//sendNotification( ApplicationFacade.FR_ALERT, illegalOperation.type );
			}
		}
		
		private function cancelHandler( event:Event ):void
		{
			//sendNotification( ApplicationFacade.FR_ALERT, event.type );
		}
		
		private function selectHandler( event:Event ):void
		{
			var strFilePath:String=event.target.nativePath;
			if (strFilePath.lastIndexOf(".")==-1){
				strFilePath	=strFilePath + "." + FORMAT
			}		
			
			var myFile:File=File.desktopDirectory.resolvePath(strFilePath);
			var fileStream:FileStream=new FileStream();
			
			fileStream.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			fileStream.addEventListener( ProgressEvent.PROGRESS, progressHandler );
			fileStream.addEventListener(Event.COMPLETE,completeHandler);
			
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
		
		private function ioErrorHandler( event:Event ):void
		{
			//sendNotification( ApplicationFacade.FR_ALERT, event );
		}
		
		private function progressHandler( event:ProgressEvent ):void
		{
			//
		}
		
		private function completeHandler( event:Event ):void
		{
			var file:FileReference = FileReference( event.target );
			var fileName:String = file.name;
			
			//sendNotification( ApplicationFacade.FR_ALERT, fileName );
		}
	}
}

