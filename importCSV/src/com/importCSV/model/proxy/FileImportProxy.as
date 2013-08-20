package com.importCSV.model.proxy
{
	import com.importCSV.view.ApplicationFacade;
	
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.*;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class FileImportProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "FileImportProxy";
		
		public var headerRow:uint=0;
		public var separator:String=";";
		
		public var f:File;
		private var ff:FileFilter;
		private var csvLines:ArrayCollection=new ArrayCollection;
		
		public function FileImportProxy()
		{
			super( NAME );	
			ff=new FileFilter("csv (*.csv)","*.csv")
		}
		
		public function getCsvLines(withHeader:Boolean):ArrayCollection
		{
			if (withHeader==false){	
				csvLines.source.slice(0,headerRow)
				return csvLines
			}else{
				return csvLines;
			}
		}
		
		public function getSeparator():String
		{
			return separator;
		}
		
		public function fileBrowse():void
		{
			f = new File();
			
			f.addEventListener( Event.CANCEL, cancelHandler );
			f.addEventListener( Event.SELECT, selectHandler );
			
			try
			{
				f.browseForOpen("open csv file",[ff])
			}
			catch (illegalOperation:IllegalOperationError )
			{
				//sendNotification( ApplicationFacade.FR_ALERT, illegalOperation.type );
			}
		}
		
		public function fileImport():void
		{
			var myFileStream:FileStream = new FileStream();
			myFileStream.open(f, FileMode.READ);			
			try
			{
				//read csv
				var str:String=myFileStream.readUTFBytes(myFileStream.bytesAvailable)
				//put csv line into array
				csvLines = new ArrayCollection(str.split("\n"));
				sendNotification( ApplicationFacade.FILE_READED_NOTIFICATION, csvLines);
			} catch(e:Error)
			{
				//send Error
				return;
			}
			myFileStream.close();	
		}
		
		public function getHeader():Array
		{
			var arrHead:Array
			var head:String
			arrHead=new Array();
			if (headerRow==0){
				for (var i:uint=1;i<20;i++){
					arrHead.push("COL" + String(i))
				}
			}else {
				head=csvLines[headerRow - 1];
				arrHead=head.split(separator);
			}
			
			return arrHead
		}
		
		private function cancelHandler( event:Event ):void
		{
			//cancel
		}
		
		private function selectHandler( event:Event ):void
		{
			//FILE SELECTED
			sendNotification( ApplicationFacade.FILE_SELECTED_NOTIFICATION, f);
		}
		
	}
}

