package com.importCSV.controller
{
	import com.importCSV.model.proxy.FileImportProxy;
	import com.importCSV.view.ApplicationFacade;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class BrowseCommand extends SimpleCommand implements ICommand
	{
		override public function execute( note:INotification ):void
		{
			var fileImportProxy:FileImportProxy = facade.retrieveProxy( FileImportProxy.NAME ) as FileImportProxy;
			
			fileImportProxy.fileBrowse();
		}
		
	}
}