package com.ecoReleve.controller
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.interceptors.*;
	import com.ecoReleve.model.DataProxy;
	import com.ecoReleve.model.DatabaseProxy;
	import com.ecoReleve.model.SelectionProxy;
	import com.ecoReleve.model.StationEnhanceProxy;
	import com.ecoReleve.view.ApplicationMediator;
	import com.ecoReleve.model.proxy.RemoteConnectorProxy;
	import com.ecoReleve.model.proxy.QueryProxy;
	import com.ecoReleve.model.proxy.StationProxy;
	import org.ns.common.controller.CommonNotificationConstants;
	
	import mx.managers.ToolTipManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;


    public class startupCommand extends SimpleFabricationCommand
    {
		override public function execute(note:INotification):void 
		{
			//register lunch command
			registerCommand(NotificationConstants.LOAD_CFG_FILE_NOTIFICATION,LoadConfigCommand)
			registerCommand(NotificationConstants.INITIALIZE_SQLITE_NOTIFICATION,SQLiteInitCommand)
			
			registerCommand(NotificationConstants.REMOVE_STATION_LAYER_NOTIFICATION,RemoveStationLayerCommand);
			
			//NEW COMMAND FOR SQLITE IMPROVEMENT
			registerCommand(NotificationConstants.SELECT_STATIONS_NOTIFICATION, GetStationsCommand);
			registerCommand(NotificationConstants.SELECT_ATTRIBUTE_NOTIFICATION, SelectAttributeCommand);
			registerCommand(NotificationConstants.LAYER_ADD_NOTIFICATION, AddLayerCommand);
			
			//export command
			registerCommand(NotificationConstants.EXPORT_FILE_NOTIFICATION,ExportStationCommand);
			
			registerCommand(NotificationConstants.SQLITE_INITIALIZED_NOTIFICATION,InitModuleCommand);
			registerCommand(NotificationConstants.LOAD_MODULE_NOTIFICATION,LoadModuleCommand);
			
			registerCommand(CommonNotificationConstants.SHOW_MODULE_NOTIFICATION,ModuleShowCommand);
			registerCommand(CommonNotificationConstants.UNLOAD_MODULE_NOTIFICATION,ModuleUnloadCommand);	
			registerCommand(CommonNotificationConstants.STATIONS_IMPORTED,StationsAddCommand);			
			
			registerInterceptor(NotificationConstants.SQLITE_INITIALIZED_NOTIFICATION,initActionsInterceptor);
			registerInterceptor(NotificationConstants.LOAD_MODULE_NOTIFICATION,loadModuleInterceptor);
			
			
			//register proxies
			registerProxy(new DatabaseProxy());
			registerProxy(new DataProxy());
			registerProxy(new StationEnhanceProxy());
			registerProxy(new SelectionProxy());
			registerProxy(new RemoteConnectorProxy());
			registerProxy(new QueryProxy());
			registerProxy(new StationProxy());
			
			
			//register main mediator
			var app:ecoReleve=note.getBody() as ecoReleve;
			registerMediator(new ApplicationMediator(app));
	
			//load config file
			//sendNotification(NotificationConstants.LOAD_CFG_FILE_NOTIFICATION)
			
			//Settings for TooltipManager
			ToolTipManager.showDelay=1000;
			ToolTipManager.hideDelay=10000;
			ToolTipManager.scrubDelay=100;			
			
			//INIT SQLITE
			sendNotification(NotificationConstants.INITIALIZE_SQLITE_NOTIFICATION);
			
		}		
    }
}