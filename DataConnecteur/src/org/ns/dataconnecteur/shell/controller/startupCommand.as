package org.ns.dataconnecteur.shell.controller
{
	import mx.managers.ToolTipManager;
	
	import org.ns.common.controller.CommonNotificationConstants;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.interceptors.*;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.EnhanceProxy;
	import org.ns.dataconnecteur.shell.model.proxy.LocalConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.ModuleProxy;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.ns.dataconnecteur.shell.model.proxy.ReleaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteDatasourceProxy;
	import org.ns.dataconnecteur.shell.model.proxy.SQLProxy;
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.ns.dataconnecteur.shell.view.ApplicationMediator;
	import org.ns.dataconnecteur.shell.view.LogMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
	
	public class startupCommand extends SimpleFabricationCommand
	{
		override public function execute(note:INotification):void 
		{
			//register command
			registerCommand(NotificationConstants.INITIALIZE_SQLITE_NOTIFICATION,SQLiteInitCommand)
			registerCommand(NotificationConstants.SQLITE_INITIALIZED_NOTIFICATION,SqliteReleaseDBCommand)
			registerCommand(NotificationConstants.SQLITE_RELEASE_CHECKED_NOTIFICATION,SqliteCheckReleaseDbCommand)		
			
			registerCommand(NotificationConstants.LOAD_MODULE_NOTIFICATION,ModuleLoadCommand)
			
			registerCommand(NotificationConstants.DELETE_ALL_STATIONS_NOTIFICATION,StationsDeleteAllCommand)
			
			registerCommand(NotificationConstants.FILE_DROPED_NOTIFICATION,FileDropedCommand)
			
			registerCommand(NotificationConstants.UPDATE_DATASOURCE,UpdateDatasourceCommand)
			registerCommand(NotificationConstants.INSERT_DATASOURCE_NOTIFICATION,DatasourceAddCommand)
			registerCommand(NotificationConstants.DELETE_DATASOURCE_NOTIFICATION,DatasourceDeleteCommand)
			
			
			registerCommand(NotificationConstants.UPDATE_QUERY_NOTIFICATION,QueryUpdateCommand)
			registerCommand(NotificationConstants.DELETE_QUERY_NOTIFICATION,QueryDeleteCommand)
			
			registerCommand(NotificationConstants.SQLITE_CLOSE_NOTIFICATION,SqliteCloseCommand)
			registerCommand(NotificationConstants.SQLITE_COMPACT_NOTIFICATION,SqliteCompactCommand)
			
			registerCommand(NotificationConstants.SELECT_ATTRIBUTE_NOTIFICATION,SelectAttributeCommand)
			
			registerCommand(NotificationConstants.ENHANCE_STATION_NOTIFICATION,EnhanceCommand)

			//register global command
			registerCommand(CommonNotificationConstants.STATIONS_IMPORTED,StationsAddCommand)
			//registerCommand(CommonNotificationConstants.STATIONS_IMPORTED_FAILED,ShowErrorCommand)
			registerCommand(CommonNotificationConstants.RECORD_QUERY_NOTIFICATION,QueryRecordCommand)
			registerCommand(CommonNotificationConstants.UNLOAD_MODULE_NOTIFICATION,ModuleUnloadCommand)		
			registerCommand(CommonNotificationConstants.SHOW_MODULE_NOTIFICATION,ModuleShowCommand)
			
			//register interceptors
			registerInterceptor(NotificationConstants.STATIONS_ADDED_NOTIFICATION,refreshReportInterceptor)
			registerInterceptor(NotificationConstants.STATIONS_DELETED_NOTIFICATION,refreshReportInterceptor)	
			registerInterceptor(NotificationConstants.DATASOURCE_UPDATED_NOTIFICATION,initActionsInterceptor)
			registerInterceptor(NotificationConstants.DATASOURCE_INSERTED_NOTIFICATION,initActionsInterceptor)
			registerInterceptor(NotificationConstants.DATASOURCE_DELETED_NOTIFICATION,initActionsInterceptor)
			registerInterceptor(NotificationConstants.SQLITE_DB_IS_READY_NOTIFICATION,initActionsInterceptor)
			registerInterceptor(NotificationConstants.SQLITE_DB_IS_READY_NOTIFICATION,refreshReportInterceptor)	
			
			registerInterceptor(NotificationConstants.LOAD_MODULE_NOTIFICATION,loadModuleInterceptor)
			
			registerInterceptor(NotificationConstants.QUERY_ADDED_NOTIFICATION,QueryAddedInterceptor)
			
			registerInterceptor(NotificationConstants.STATIONS_ENHANCED_NOTIFICATION,stationEnhancedInterceptor)
			
			//register proxy
			registerProxy(new StationProxy());
			registerProxy(new QueryProxy());
			registerProxy(new RemoteDatasourceProxy());
			registerProxy(new ModuleProxy());
			registerProxy(new DatabaseProxy());
			registerProxy(new SQLProxy());
			registerProxy(new RemoteConnectorProxy());
			registerProxy(new LocalConnectorProxy());
			registerProxy(new EnhanceProxy());
			registerProxy(new ReleaseProxy());
			
			//register main mediator
			var app:DataConnecteur=note.getBody() as DataConnecteur;
			registerMediator(new ApplicationMediator(app));
			
			//register log mediator
			registerMediator(new LogMediator(app.Log));
			
			//Settings for TooltipManager
			ToolTipManager.showDelay=1000;
			ToolTipManager.hideDelay=10000;
			ToolTipManager.scrubDelay=100;
			
		}		
	}
}

