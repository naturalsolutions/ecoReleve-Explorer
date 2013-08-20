package org.ns.RemoteImportModule.controller
{

	import org.ns.RemoteImportModule.controller.*;
	import org.ns.RemoteImportModule.interceptors.*;
	import org.ns.RemoteImportModule.model.proxy.ConnectorProxy;
	import org.ns.RemoteImportModule.model.proxy.RemoteStationProxy;
	import org.ns.RemoteImportModule.view.ApplicationMediator;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class moduleStartupCommand extends SimpleFabricationCommand
	{
		override public function execute(note:INotification):void 
		{
			//register mediator
			var module:RemoteImportModule=note.getBody() as RemoteImportModule
			registerMediator(new ApplicationMediator(module));
			
			//register proxy
			registerProxy(new RemoteStationProxy());
			registerProxy(new ConnectorProxy());
			
			//register command
			registerCommand(CommonNotificationConstants.INIT_MODULE_NOTIFICATION, InitModuleCommand);
			registerCommand(NotificationConstants.LOAD_STATIONS_NOTIFICATION, StationsloadRemoteCommand);
			registerCommand(NotificationConstants.STATIONS_SELECTED_NOTIFICATIONS,StationsResultProcessCommand);
			registerCommand(NotificationConstants.TEST_QUERY_NOTIFICATION,QueryTestCommand);
			registerCommand(NotificationConstants.RECORD_QUERY_NOTIFICATION,QueryRecordCommand);
			
			//registerInterceptors
			registerInterceptor(NotificationConstants.STATIONS_COUNTED_NOTIFICATIONS,StationsCountedInterceptor);
		}
	}
}