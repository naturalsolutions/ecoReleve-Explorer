package org.ns.XmlImportModule.controller
{

	import org.ns.XmlImportModule.controller.NotificationConstants;
	import org.ns.XmlImportModule.model.proxy.FileXMLProxy;
	import org.ns.XmlImportModule.view.ApplicationMediator;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class moduleStartupCommand extends SimpleFabricationCommand
	{
		override public function execute(note:INotification):void 
		{
			//register mediator
			var module:XmlImportModule=note.getBody() as XmlImportModule
			registerMediator(new ApplicationMediator(module));
			
			//register proxy
			registerProxy(new FileXMLProxy());
			
			//register command
			registerCommand(CommonNotificationConstants.INIT_MODULE_NOTIFICATION, InitModuleCommand);
			registerCommand(NotificationConstants.BROWSE_NOTIFICATION, BrowseCommand);
			
			registerCommand(NotificationConstants.IMPORT_FILE_NOTIFICATION, ImportFileCommand);
			registerCommand(NotificationConstants.FILE_IMPORTED_NOTIFICATION, ImportStationsCommand);
			
		}
	}
}