package org.ns.CsvImportModule.model.proxy
{
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.*;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.CsvImportModule.controller.*;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class FileCSVProxy extends FabricationProxy
	{
		public static const NAME:String = "FileCsvProxy";
		
		public var headerRow:uint=0;
		public var separator:String=";";
		
		public var f:File;
		private var ff:FileFilter;
		private var csvLines:ArrayCollection=new ArrayCollection;
		
		public function FileCSVProxy()
		{
			super( NAME );	
			ff=new FileFilter("csv (*.csv)","*.csv")
		}
		
		public function getCsvLines(withHeader:Boolean):ArrayCollection
		{
			var i:int;
			
			if (withHeader==false){	
				for (i=0;i<headerRow;i++){
					csvLines.removeItemAt(0);
				}
				return csvLines
			}else{
				for (i=0;i<headerRow-1;i++){
					csvLines.removeItemAt(0);
				}
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
					//put csv line into arrayCollection
				var arr:Array=str.split("\n");
				csvLines = new ArrayCollection();
				var i:int=1;
				for each(var strLine:String in arr){
					csvLines.addItem({rowNb:i,line:strLine});
					i++
				}				
				sendNotification( NotificationConstants.FILE_IMPORTED_NOTIFICATION, csvLines);
			} catch(e:Error)
			{
				//send Error
				return;
			}
			myFileStream.close();	
		}
		
		public function getFile():File
		{
			return f;
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
				head=csvLines[headerRow - 1].line;
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
			sendNotification( NotificationConstants.FILE_SELECTED_NOTIFICATION, f);
		}
		
	}
}

