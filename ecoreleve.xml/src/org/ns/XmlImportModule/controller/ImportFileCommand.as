package org.ns.XmlImportModule.controller
{
	import org.ns.XmlImportModule.model.proxy.FileXMLProxy
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.*;
	
	public class ImportFileCommand extends SimpleFabricationCommand
	{
		override public function execute( note:INotification ):void
		{
			var fileXmlProxy:FileXMLProxy = retrieveProxy(FileXMLProxy.NAME) as FileXMLProxy;
			
			//assign the file to import to the proxy
			var dataModel:Object=note.getBody() as Object
			var myFile:File=dataModel.file as File
			fileXmlProxy.f=myFile;
			
			//do the import
			fileXmlProxy.fileImport();
		}
		
	}
}