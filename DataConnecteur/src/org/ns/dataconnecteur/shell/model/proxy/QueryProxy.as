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
	
	import org.ns.common.model.VO.QueryVO;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.model.DAO.QueryDAO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class QueryProxy extends FabricationProxy
	{
		public static const NAME:String = "QueryProxy";	
		
		private var collQuery:ArrayCollection=new ArrayCollection();
		
		public function QueryProxy()
		{
			super(NAME);	
		}

		public function get getQueryCollection():ArrayCollection
		{
			return collQuery
		}
		
		public function addQuery(conn:SQLConnection,query:QueryVO):void
		{
			var dao:QueryDAO=QueryDAO.getInstance()
			dao.setConnection(conn)
			dao.insertRow(query,addQueryResultHandler,addQueryErrorHandler)
		}
		
		public function selectQueries(conn:SQLConnection):void
		{
			var dao:QueryDAO=QueryDAO.getInstance()
			dao.setConnection(conn)
			dao.selectAll(selectAllResultHandler,selectAllErrorHandler)
		}
		
		public function deleteQuery(conn:SQLConnection,query:QueryVO):void
		{
			var dao:QueryDAO=QueryDAO.getInstance()
			dao.setConnection(conn)
			dao.deleteRow(query,deleteQueryResultHandler,deleteQueryErrorHandler)
		}
		
		public function deleteUnpersistentQuery(conn:SQLConnection):void
		{
			var dao:QueryDAO=QueryDAO.getInstance()
			dao.setConnection(conn)
			dao.deleteUnpersistentQuery(deleteUnpersistentQueryResultHandler,deleteQUnpersistentueryErrorHandler)
		}
		
		public function countQueries(conn:SQLConnection):void
		{
			var dao:QueryDAO=QueryDAO.getInstance()
			dao.setConnection(conn)
			dao.countAll(countAllResultHandler,countAllErrorHandler)							
		}
		
		public function usedQueries(conn:SQLConnection):void
		{
			var dao:QueryDAO=QueryDAO.getInstance()
			dao.setConnection(conn)
			dao.used(usedResultHandler,usedErrorHandler)							
		}
		
		public function updateQuery(conn:SQLConnection,query:QueryVO):void
		{
			var dao:QueryDAO=QueryDAO.getInstance()
			dao.setConnection(conn)
			dao.updateRow(query,updateResultHandler,updateErrorHandler)							
		}
		
		//HANDLERS
		//INSERT ROW
		private function addQueryResultHandler(query:QueryVO):void
		{
			trace("add "+ query)
			collQuery.addItem(query);
			sendNotification(NotificationConstants.QUERY_ADDED_NOTIFICATION,query);
		}
		
		private function addQueryErrorHandler(event:SQLErrorEvent):void
		{
			trace("query add error: " + event.error.details);
		}
		
		//SELECT
		private function selectAllResultHandler(queries:ArrayCollection):void
		{
			trace(queries)
			collQuery.removeAll()
			collQuery=queries
			sendNotification(NotificationConstants.QUERY_SELECTED_NOTIFICATION);
		}
		
		private function selectAllErrorHandler(event:SQLErrorEvent):void
		{
			trace("query select error: " + event.error.details)
		}
		
		//SELECT
		private function usedResultHandler(queries:ArrayCollection):void
		{
			trace(queries)
			sendNotification(NotificationConstants.QUERY_USED_NOTIFICATION,queries);
		}
		
		private function usedErrorHandler(event:SQLErrorEvent):void
		{
			trace("query used error: " + event.error.details)
		}
		
		
		//DELETE QUERY
		private function deleteQueryResultHandler(query:QueryVO):void
		{
			trace("delete " + query)
			collQuery.removeItemAt(collQuery.getItemIndex(query));
			sendNotification(NotificationConstants.QUERY_DELETED_NOTIFICATION);
		}
		
		private function deleteQueryErrorHandler(event:SQLErrorEvent):void
		{
			trace("query delete error: " + event.error.details);
		}
		
		//DELETE Unpersistent
		private function deleteUnpersistentQueryResultHandler():void
		{
			trace("delete unpersistent queries")
			sendNotification(NotificationConstants.QUERY_UNPERSISTENT_DELETED_NOTIFICATION);
		}
		
		private function deleteQUnpersistentueryErrorHandler(event:SQLErrorEvent):void
		{
			trace("query delete error: " + event.error.details);
		}
		
		
		//COUNT
		private function countAllResultHandler(queriesCounted:Number):void
		{
			trace(queriesCounted)
			sendNotification(NotificationConstants.QUERY_COUNTED_NOTIFICATION,queriesCounted)
		}
		
		private function countAllErrorHandler(event:SQLErrorEvent):void
		{
			trace("query count all error: " + event.error.details)
		}
		
		//UPDATE
		private function updateResultHandler(query:QueryVO):void
		{
			trace("update " + query)
			sendNotification(NotificationConstants.QUERY_UPDATED_NOTIFICATION,query)
		}
		
		private function updateErrorHandler(event:SQLErrorEvent):void
		{
			trace("query update error: " + event.error.details)
		}
	}
}

