package org.ns.CsvImportModule.controller
{
	import org.ns.CsvImportModule.model.proxy.FileCSVProxy;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	
	public class ImportFileCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var fileCsvProxy:FileCSVProxy = retrieveProxy(FileCSVProxy.NAME) as FileCSVProxy;
			
			//assign the file to import to the proxy
			var myFile:File=note.getBody() as File
			fileCsvProxy.f=myFile;
			
			//do the import
			fileCsvProxy.fileImport();
		}
		
	}
}