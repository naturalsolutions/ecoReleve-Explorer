package org.ns.CsvImportModule.controller
{

	import org.ns.common.controller.CommonNotificationConstants
	import org.ns.CsvImportModule.controller.*;
	import org.ns.CsvImportModule.model.proxy.FileCSVProxy;
	import org.ns.CsvImportModule.view.ApplicationMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class moduleStartupCommand extends SimpleFabricationCommand
	{
		override public function execute(note:INotification):void 
		{
			//register mediator
			var module:CsvImportModule=note.getBody() as CsvImportModule
			registerMediator(new ApplicationMediator(module));
			
			//register proxy
			registerProxy(new FileCSVProxy);
			
			//register command
			registerCommand(CommonNotificationConstants.INIT_MODULE_NOTIFICATION, InitModuleCommand);
			registerCommand(NotificationConstants.BROWSE_NOTIFICATION, BrowseCommand);
			registerCommand(NotificationConstants.IMPORT_FILE_NOTIFICATION, ImportFileCommand);
			registerCommand(NotificationConstants.READ_HEADER_NOTIFICATION, ReadHeaderCommand);
			registerCommand(NotificationConstants.CREATE_STATIONS_NOTIFICATION, ImportStationsCommand);
			
		}
	}
}