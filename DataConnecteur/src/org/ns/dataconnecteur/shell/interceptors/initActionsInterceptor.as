package org.ns.dataconnecteur.shell.interceptors
{
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	
	import org.ns.dataconnecteur.shell.controller.NotificationConstants;
	import org.ns.dataconnecteur.shell.model.proxy.DatabaseProxy;
	import org.ns.dataconnecteur.shell.model.proxy.LocalConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.ModuleProxy;
	import org.ns.dataconnecteur.shell.model.proxy.QueryProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteConnectorProxy;
	import org.ns.dataconnecteur.shell.model.proxy.RemoteDatasourceProxy;
	import org.ns.dataconnecteur.shell.model.proxy.SQLProxy;
	import org.ns.dataconnecteur.shell.model.proxy.StationProxy;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.interceptor.AbstractInterceptor;
	
	public class initActionsInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy;
			var pxyRemoteConnector:RemoteConnectorProxy=retrieveProxy(RemoteConnectorProxy.NAME) as RemoteConnectorProxy;
			var pxyLocalConnector:LocalConnectorProxy=retrieveProxy(LocalConnectorProxy.NAME) as LocalConnectorProxy;	
			var pxyModule:ModuleProxy=retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			var pxyDatasource:RemoteDatasourceProxy=retrieveProxy(RemoteDatasourceProxy.NAME) as RemoteDatasourceProxy;
			
			//get all queries
			pxyQuery.selectQueries(pxyDatabase.getSqlConnexion);		
			//get all remote and local connectors (Module join Datasource)
			pxyRemoteConnector.selectConnectors(pxyDatabase.getSqlConnexion);
			pxyLocalConnector.selectConnectors(pxyDatabase.getSqlConnexion);
			//get all modules
			pxyModule.selectModules(pxyDatabase.getSqlConnexion);
			//get all datasources
			pxyDatasource.selectDatasources(pxyDatabase.getSqlConnexion);
			
			sendNotification(NotificationConstants.LOG_NOTIFICATION,'APP:DB INIT SQL')
			
			this.proceed();
	
		}
	}
}