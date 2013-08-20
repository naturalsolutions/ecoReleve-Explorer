package org.ns.dataconnecteur.shell.model.proxy
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.DAO.SQLDAO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class SQLProxy extends FabricationProxy
	{
		public static const NAME:String = "SQLProxy";	
		
		
		public function SQLProxy()
		{
			super(NAME);	
		}
		
		public function selectStationsWithQueryAndDatasource(conn:SQLConnection):void
		{
			var dao:SQLDAO=SQLDAO.getInstance()
			dao.setConnection(conn)
			dao.selectStationsJoinQuery(selectAllResultHandler,selectErrorHandler)
		}
		
		public function selectResumeSourceData(conn:SQLConnection):void
		{
			var dao:SQLDAO=SQLDAO.getInstance()
			dao.setConnection(conn)
			dao.selectResumeSourceData(selectResumeDatasourceResultHandler,selectErrorHandler)
		}
				
		
		//HANDLERS
		//SELECT
		private function selectAllResultHandler(data:ArrayCollection):void
		{
			trace(data)
			sendNotification(NotificationConstants.STATION_JOIN_QUERY_SELECTED_NOTIFICATION,data);
		}
		
		private function selectResumeDatasourceResultHandler(data:ArrayCollection):void
		{
			trace(data)
			sendNotification(NotificationConstants.STATION_RESUME_DATASOURCE_NOTIFICATION,data);
		}
		
		private function selectErrorHandler(event:SQLErrorEvent):void
		{
			trace("sql error: " + event.error.details)
		}
	}
}

