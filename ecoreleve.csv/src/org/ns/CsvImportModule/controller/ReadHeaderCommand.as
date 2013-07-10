package org.ns.CsvImportModule.controller
{
	import org.ns.CsvImportModule.model.proxy.FileCSVProxy;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	
	public class ReadHeaderCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var fileCsvProxy:FileCSVProxy = retrieveProxy( FileCSVProxy.NAME ) as FileCSVProxy;
			var arrHeaderField:ArrayCollection=new ArrayCollection;
			
			//get parameters (headerRow and separator) from body notification
			var arrParameters:Array=note.getBody() as Array
			var headerRow:uint=uint(arrParameters[0]);	
			var separator:String=String(arrParameters[1]);	
			
			//define header row in proxy
			fileCsvProxy.headerRow=headerRow;
			fileCsvProxy.separator=separator;
			
			//add NONE value to the begining of the arrayCollection
			var arr:Array=fileCsvProxy.getHeader();
			arr.unshift("NONE");
			arrHeaderField=new ArrayCollection(arr);
			
			
			sendNotification(NotificationConstants.HEADER_READED_NOTIFICATION,arrHeaderField);
		}
		
	}
}