package org.ns.XmlImportModule.model.proxy
{
	import flash.errors.IllegalOperationError;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.*;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.XmlImportModule.controller.*;
	import org.puremvc.as3.multicore.interfaces.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class FileXMLProxy extends FabricationProxy
	{
		public static const NAME:String = "FileXmlProxy";
		
		public var f:File;
		private var _extension:String
		private var ff:FileFilter;
		
		public function FileXMLProxy()
		{
			super( NAME );	
		}
		public function get extension():String
		{
			return _extension
		}
		
		public function set extension(value:String):void
		{
			_extension=value	
		}
		
		public function fileBrowse():void
		{
			f = new File();
			
			f.addEventListener( Event.CANCEL, cancelHandler );
			f.addEventListener( Event.SELECT, selectHandler );
			
			try
			{
				ff=new FileFilter(_extension + " (*." + _extension + ")","*."+ _extension )
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
				//read xml
				var data:String=myFileStream.readUTFBytes(myFileStream.bytesAvailable)
				var xml:XML=new XML(data)			
				sendNotification( NotificationConstants.FILE_IMPORTED_NOTIFICATION, xml);
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

