package com.ecoReleve.model.proxy
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.StationVO;
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DAO.StationDAO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class StationProxy extends FabricationProxy
	{
		public static const NAME:String = "StationProxy";		
		public function StationProxy()
		{
			super(NAME);	
		}
		
		public function addStations(conn:SQLConnection,stations:ArrayCollection):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.insertBatchRow(stations.source,insertCommitHandler,insertRollbackHandler);
		}
		
		public function deleteStations(conn:SQLConnection):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.deleteAll(deleteAllResultHandler,deleteAllErrorHandler)							
		}
		
		public function countStations(conn:SQLConnection):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.countAll(countAllResultHandler,countAllErrorHandler)							
		}
		public function selectDistinctValue(attribute:String,conn:SQLConnection):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.selectDistinct(attribute,true,selectDistinctResultHandler,selectDistinctErrorHandler)							
		}
		
		public function selectAllStations(conn:SQLConnection):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.selectAll(selectAllResultHandler,selectAllErrorHandler)							
		}
		
		//HANDLERS
		
		//INSERT BATCH ROWS
		private function insertCommitHandler(stationAdded:Number):void
		{
			trace(stationAdded);
			sendNotification(NotificationConstants.STATIONS_ADDED_NOTIFICATION,stationAdded);
		}
		
		private function insertRollbackHandler(event:SQLErrorEvent):void
		{
			trace("station rollback: " + event.error.details)
		}
		
		//COUNT ALL
		private function countAllResultHandler(stationsCounted:Number):void
		{
			trace(stationsCounted)
			//sendNotification(NotificationConstants.STATIONS_COUNTED_NOTIFICATION,stationsCounted)
		}
		
		private function countAllErrorHandler(event:SQLErrorEvent):void
		{
			trace("station count error: " + event.error.details)
		}
		
		//SELECT DISINCT
		private function selectDistinctResultHandler(items:ArrayCollection):void
		{
			trace(items)
			//sendNotification(NotificationConstants.ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION,items);
		}
		
		private function selectDistinctErrorHandler(event:SQLErrorEvent):void
		{
			trace("Select distinct error: " + event.error.details)
		}
		
		//SELECT ALL
		private function selectAllResultHandler(stations:ArrayCollection):void
		{
			trace(stations)
			//sendNotification(NotificationConstants.STATIONS_SELECTED_NOTIFICATION ,stations);
		}
		
		private function selectAllErrorHandler(event:SQLErrorEvent):void
		{
			trace("station select error: " + event.error.details)
		}
		
		//DELETEALL
		private function deleteAllResultHandler():void
		{
			sendNotification(NotificationConstants.STATIONS_DELETED_NOTIFICATION)
			//sendNotification(NotificationConstants.LOG_NOTIFICATION,"all stations deleted")
		}
		
		private function deleteAllErrorHandler(event:SQLErrorEvent):void
		{
			trace("station delete error: " + event.error.details)
		}
		
	}
}

