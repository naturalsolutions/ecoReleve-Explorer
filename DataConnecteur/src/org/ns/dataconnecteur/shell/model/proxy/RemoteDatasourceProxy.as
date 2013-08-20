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
	
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.DAO.RemoteDatasourceDAO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class RemoteDatasourceProxy extends FabricationProxy
	{
		public static const NAME:String = "DatasourceProxy";	
		
		private var datasources:ArrayCollection=new ArrayCollection();
		
		public function RemoteDatasourceProxy()
		{
			super(NAME);	
		}

		public function get getDatasources():ArrayCollection
		{
			return datasources
		}
		
		public function getDatasourceByModuleId(moduleId:int):RemoteDatasourceVO
		{
			var datasource:RemoteDatasourceVO;
	
			for each(datasource in datasources){
				if (datasource.rd_fkModule==moduleId){
					return datasource
				}
			}
				
			return null
		}
		
		public function selectDatasources(conn:SQLConnection):void
		{
			var dao:RemoteDatasourceDAO=RemoteDatasourceDAO.getInstance()
			dao.setConnection(conn)
			dao.selectAll(selectAllResultHandler,selectAllErrorHandler)
		}
		
		public function update(conn:SQLConnection,row:RemoteDatasourceVO):void
		{
			var dao:RemoteDatasourceDAO=RemoteDatasourceDAO.getInstance()
			dao.setConnection(conn)
			dao.updateRow(row,updateResultHandler,updateErrorHandler)
		}
		
		public function addDatasource(conn:SQLConnection,row:RemoteDatasourceVO):void
		{
			var dao:RemoteDatasourceDAO=RemoteDatasourceDAO.getInstance()
			dao.setConnection(conn)
			dao.insertRow(row,insertResultHandler,insertErrorHandler)
		}
		
		public function deleteDatasource(conn:SQLConnection,row:RemoteDatasourceVO):void
		{
			var dao:RemoteDatasourceDAO=RemoteDatasourceDAO.getInstance()
			dao.setConnection(conn)
			dao.deleteRow(row,deleteResultHandler,deleteErrorHandler)
		}
		
		//HANDLERS
		//SELECT
		private function selectAllResultHandler(collDatasources:ArrayCollection):void
		{
			trace(collDatasources)
			datasources.removeAll()
			datasources=collDatasources
			sendNotification(NotificationConstants.DATASOURCE_SELECTED_NOTIFICATION);
		}
		
		private function selectAllErrorHandler(event:SQLErrorEvent):void
		{
			trace(event.errorID)
		}
		
		//UPDATE
		private function updateResultHandler(datasource:RemoteDatasourceVO):void
		{
			trace(datasource)
			sendNotification(NotificationConstants.DATASOURCE_UPDATED_NOTIFICATION);
		}
		
		private function updateErrorHandler(event:SQLErrorEvent):void
		{
			trace('remote datasource update error' + event.error.details)
		}
		
		//INSERT
		private function insertResultHandler(datasource:RemoteDatasourceVO):void
		{
			trace(datasource)
			datasources.addItem(datasource)
			sendNotification(NotificationConstants.DATASOURCE_INSERTED_NOTIFICATION);
		}
		
		private function insertErrorHandler(event:SQLErrorEvent):void
		{
			trace('remote datasource insert error' + event.error.details)
		}
		
		//DELETE
		private function deleteResultHandler(datasource:RemoteDatasourceVO):void
		{
			trace("delete " + datasource)
			datasources.removeItemAt(datasources.getItemIndex(datasource));
			sendNotification(NotificationConstants.DATASOURCE_DELETED_NOTIFICATION);
		}
		
		private function deleteErrorHandler(event:SQLErrorEvent):void
		{
			trace("datasource delete error: " + event.error.details);
		}
		
		
	}
}

