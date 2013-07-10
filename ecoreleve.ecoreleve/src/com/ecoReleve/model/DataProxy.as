package com.ecoReleve.model
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DAO.StationDAO;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.StationVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class DataProxy extends FabricationProxy
	{
		public static const NAME:String = "DataProxy";	
		
		public var stations:ArrayCollection=new ArrayCollection();
		private var arrFilterParameters:Array=new Array();
		
		public function DataProxy()
		{
			super(NAME);	
		}
		
		public function selectStations(conn:SQLConnection,where:String=null):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.select(selectResultHandler,selectErrorHandler,where)							
		}
		
		public function selectDistinctValue(attribute:String,conn:SQLConnection):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.selectDistinct(attribute,true,selectDistinctResultHandler,selectErrorHandler)							
		}
		
		public function selectMinMax(attribute:String,conn:SQLConnection):void
		{
			var dao:StationDAO=StationDAO.getInstance()
			dao.setConnection(conn)
			dao.selectMinMax(attribute,selectMinMaxResultHandler,selectErrorHandler)							
		}
		
		//HANDLERS

		//SELECT 
		private function selectResultHandler(items:ArrayCollection):void
		{
			stations.removeAll()
			stations=items
			sendNotification(NotificationConstants.STATIONS_ADDED_NOTIFICATION,stations);
		}
		
		private function selectDistinctResultHandler(items:ArrayCollection):void
		{
			sendNotification(NotificationConstants.ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION,items);
		}
		
		private function selectMinMaxResultHandler(items:ArrayCollection):void
		{
			sendNotification(NotificationConstants.ATTRIBUTE_MINMAX_ADDED_NOTIFICATION,items);
		}
		
		private function selectErrorHandler(event:SQLErrorEvent):void
		{
			trace("station select error: " + event.error.details)
		}
	}
}