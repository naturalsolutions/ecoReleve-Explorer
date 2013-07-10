package org.ns.dataconnecteur.shell.controller
{
	import flash.desktop.NativeApplication;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.LocalConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.ModuleProxy;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteDatasourceProxy;
	import org.ns.dataconnecteur.shell.model.proxy.SQLProxy;
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;

	public class SqliteCheckReleaseDbCommand extends SimpleFabricationCommand
	{
		
		override public function execute(note:INotification):void 
		{ 	
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy
			
			//get application release
			var updateDbVersion:String=DatabaseProxy.DB_RELEASE;
			
			//get db release
			var currentDbVersion:String=note.getBody() as String;
			
			sendNotification(NotificationConstants.LOG_NOTIFICATION,'INIT:DB CHECKED')
			
			//TEST
			if (updateDbVersion==currentDbVersion){
				var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy;		
				var pxyRemoteConnector:RemoteConnectorProxy=retrieveProxy(RemoteConnectorProxy.NAME) as RemoteConnectorProxy;
				var pxyLocalConnector:LocalConnectorProxy=retrieveProxy(LocalConnectorProxy.NAME) as LocalConnectorProxy;	
				var pxyModule:ModuleProxy=retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
				var pxyDatasource:RemoteDatasourceProxy=retrieveProxy(RemoteDatasourceProxy.NAME) as RemoteDatasourceProxy;
				var pxyStation:StationProxy=retrieveProxy(StationProxy.NAME) as StationProxy;
				var pxySQL:SQLProxy=retrieveProxy(SQLProxy.NAME) as SQLProxy;
				
				//get all queries
				pxyQuery.selectQueries(pxyDatabase.getSqlConnexion);		
				//get all remote and local connectors (Module join Datasource)
				pxyRemoteConnector.selectConnectors(pxyDatabase.getSqlConnexion);
				pxyLocalConnector.selectConnectors(pxyDatabase.getSqlConnexion);
				//get all modules
				pxyModule.selectModules(pxyDatabase.getSqlConnexion);
				//get all datasources
				pxyDatasource.selectDatasources(pxyDatabase.getSqlConnexion);
				
				//count stations
				pxyStation.countStations(pxyDatabase.getSqlConnexion);	
				//Resume Source data
				pxySQL.selectResumeSourceData(pxyDatabase.getSqlConnexion);		
				//OLAP data
				pxySQL.selectStationsWithQueryAndDatasource(pxyDatabase.getSqlConnexion);			
				//count queries
				pxyQuery.countQueries(pxyDatabase.getSqlConnexion);			
				//get used queries
				pxyQuery.usedQueries(pxyDatabase.getSqlConnexion);

				sendNotification(NotificationConstants.LOG_NOTIFICATION,'INIT:DB READY')
				sendNotification(NotificationConstants.SQLITE_DB_IS_READY_NOTIFICATION)
			} else{
				//close connection
				Alert.okLabel = "yes";
				Alert.noLabel="no";
				Alert.show("The database will be recreated because of shema change. \nYou will lose your queries and your passwords. \nWould you like to make a copy (on the desktop) of the database before?", "recreate database", Alert.OK|Alert.NO, null, closeListener);				
			}
		}
		
		private function closeListener(event:CloseEvent):void 
		{
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy
			
			if (event.detail==Alert.OK) {
				pxyDatabase.backup();
				pxyDatabase.recreate();
			}else {
				pxyDatabase.recreate();
			}
		}
	}
}