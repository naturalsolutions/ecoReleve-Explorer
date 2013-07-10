package org.ns.CsvImportModule.controller
{
	import org.ns.CsvImportModule.model.proxy.FileCSVProxy;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	
	public class BrowseCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var fileCsvProxy:FileCSVProxy = facade.retrieveProxy( FileCSVProxy.NAME ) as FileCSVProxy;
			
			fileCsvProxy.fileBrowse();
		}
		
	}
}