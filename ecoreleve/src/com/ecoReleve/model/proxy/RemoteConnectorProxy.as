package com.ecoReleve.model.proxy
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DAO.SQLDAO;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class RemoteConnectorProxy extends FabricationProxy
	{
		public static const NAME:String = "RemoteConnectorProxy";	
		
		public static var connectors:ArrayCollection=new ArrayCollection();
		
		public function RemoteConnectorProxy()
		{
			super(NAME);	
		}

		public function get getConnectors():ArrayCollection
		{
			return connectors
		}
		
		public function getConnectorByModuleName(moduleName:String):RemoteConnectorVO
		{
			var connector:RemoteConnectorVO;
			
			for each(connector in connectors){
				if (connector.mod_name.toLowerCase()==moduleName){
					return connector
				}
			}
			
			return null
		}
		
		
		public function selectConnectors(conn:SQLConnection):void
		{
			var dao:SQLDAO=SQLDAO.getInstance()
			dao.setConnection(conn)
			dao.selectModuleJoinRemoteDatasource(selectAllResultHandler2,selectAllErrorHandler)
		}
		
		//HANDLERS
		//SELECT
		private function selectAllResultHandler(data:ArrayCollection):void
		{
			trace(data[0])
			connectors.removeAll()
			connectors=data
			sendNotification(NotificationConstants.CONNECTORS_REMOTE_SELECTED_NOTIFICATION,connectors);
		}
		
		private function selectAllResultHandler2(data:ArrayCollection):void
		{
			trace("remoteconnectorproxy data0 : "+data[0] +" logo : "+data[0].rd_logo);
			connectors.removeAll();				
			connectors=data;
			sendNotification(NotificationConstants.SQLITE_INITIALIZED_NOTIFICATION,connectors as ArrayCollection);
			
		}
		
		private function selectAllErrorHandler(event:SQLErrorEvent):void
		{
			trace(event.errorID)
		}
	}
}

