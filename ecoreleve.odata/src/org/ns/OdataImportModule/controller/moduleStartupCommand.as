package org.ns.OdataImportModule.controller
{

	import org.ns.OdataImportModule.controller.*;
	import org.ns.OdataImportModule.interceptors.*;
	import org.ns.OdataImportModule.model.proxy.ConnectorProxy;
	import org.ns.OdataImportModule.model.proxy.MetadataProxy;
	import org.ns.OdataImportModule.model.proxy.ModuleProxy;
	import org.ns.OdataImportModule.model.proxy.RemoteStationProxy;
	import org.ns.OdataImportModule.model.proxy.StationProxy;
	import org.ns.OdataImportModule.view.ApplicationMediator;
	import org.ns.common.controller.CommonNotificationConstants;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class moduleStartupCommand extends SimpleFabricationCommand
	{
		override public function execute(note:INotification):void 
		{
			//register mediator
			var module:OdataImportModule=note.getBody() as OdataImportModule
			registerMediator(new ApplicationMediator(module));
			
			//register proxy
			registerProxy(new RemoteStationProxy());
			registerProxy(new ConnectorProxy());
			registerProxy(new MetadataProxy());
			registerProxy(new ModuleProxy());
			registerProxy(new StationProxy());
			
			//register command
			registerCommand(CommonNotificationConstants.INIT_MODULE_NOTIFICATION, InitModuleCommand);
			registerCommand(NotificationConstants.LOAD_STATIONS_NOTIFICATION, StationsloadRemoteCommand);
			registerCommand(NotificationConstants.TEST_QUERY_NOTIFICATION,QueryTestCommand);
			registerCommand(NotificationConstants.RECORD_QUERY_NOTIFICATION,QueryRecordCommand);
			registerCommand(NotificationConstants.METADATA_GET_NOTIFICATION,MetadataGetCommand);
			
			//registerInterceptors
			registerInterceptor(NotificationConstants.STATIONS_COUNTED_NOTIFICATIONS,StationsCountedInterceptor);
			registerInterceptor(NotificationConstants.STATIONS_SELECTED_NOTIFICATIONS,StationsSelectedInterceptor);
		}
	}
}