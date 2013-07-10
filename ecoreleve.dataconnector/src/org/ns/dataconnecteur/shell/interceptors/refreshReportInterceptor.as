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
	
	public class refreshReportInterceptor extends AbstractInterceptor
	{
		override public function intercept():void 
		{
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			var pxyQuery:QueryProxy=retrieveProxy(QueryProxy.NAME) as QueryProxy;		
			var pxyStation:StationProxy=retrieveProxy(StationProxy.NAME) as StationProxy;
			var pxySQL:SQLProxy=retrieveProxy(SQLProxy.NAME) as SQLProxy;
			
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
			
			sendNotification(NotificationConstants.LOG_NOTIFICATION,'APP:DB REFRESH REPORTING')
			
			this.proceed();
	
		}
	}
}