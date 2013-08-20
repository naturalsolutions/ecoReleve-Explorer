package org.ns.XmlImportModule.controller
{
	import org.ns.XmlImportModule.model.proxy.FileXMLProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class BrowseCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var fileXmlProxy:FileXMLProxy = facade.retrieveProxy( FileXMLProxy.NAME ) as FileXMLProxy;
			
			fileXmlProxy.fileBrowse();
		}
		
	}
}