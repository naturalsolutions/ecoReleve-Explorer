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
	import org.ns.dataconnecteur.shell.model.DAO.EnhanceDAO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class EnhanceProxy extends FabricationProxy
	{
		public static const NAME:String = "EnhanceProxy";	
		
		private var _Items:ArrayCollection;
		private var _Conn:SQLConnection;
		
		public function EnhanceProxy()
		{
			super(NAME);	
		}

		public function dropTable(conn:SQLConnection):void
		{
			var dao:EnhanceDAO=EnhanceDAO.getInstance()
			dao.setConnection(conn)
			dao.dropTable(dropTableHandler,dropTableErrorHandler)
		}
		
		public function enhanceData(conn:SQLConnection,items:ArrayCollection):void
		{
			//get data public
			_Items=new ArrayCollection();
			_Items=items;
			
			//get connection public
			_Conn=new SQLConnection();
			_Conn=conn;	
				
			recreateTable()	
		}
		
		private function recreateTable():void
		{
			var dao:EnhanceDAO=EnhanceDAO.getInstance()
			dao.setConnection(_Conn)
			dao.dropTable(recreateTableHandler,recreateTableErrorHandler)	
		}
		
		private function createTable():void
		{
			var dao:EnhanceDAO=EnhanceDAO.getInstance()
			dao.setConnection(_Conn)
			dao.createTable(createTableHandler,createTableErrorHandler)	
		}
		
		private function addColumns(cols:Array):void
		{
			var dao:EnhanceDAO=EnhanceDAO.getInstance()
			dao.setConnection(_Conn)
			dao.insertBatchCol(cols,addColumnHandler,addColumnErrorHandler);
		}
		
		private function addEnhanceItems(items:ArrayCollection):void
		{
			var dao:EnhanceDAO=EnhanceDAO.getInstance()
			dao.setConnection(_Conn)
			dao.insertBatchRow(items.source,insertCommitHandler,insertRollbackHandler);
		}
		
		
		//HANDLERS
		//DROP TABLE
		private function dropTableHandler():void
		{
			trace('table Enhance droped');
		}
		
		private function dropTableErrorHandler():void
		{
			trace("table Ehance droped error")
		}
		
		//RECREATE TABLE
		private function recreateTableHandler():void
		{
			trace('table Enhance droped');
			createTable()
		}
		
		private function recreateTableErrorHandler():void
		{
			trace("table Ehance droped error")
		}
		
		//CREATE TABLE
		private function createTableHandler():void
		{
			trace('table Enhance created');
			//add columns
			var cols:Array=new Array()
			for (var p:String in _Items[0]) {
				cols.push(p);
			}
			addColumns(cols)
		}
		
		private function createTableErrorHandler():void
		{
			trace("table Enhance created error")
		}
		
		
		//ADD COLUMN
		private function addColumnHandler(colAdded:Number):void
		{
			trace('columns added:' + colAdded.toString());
			addEnhanceItems(_Items)
		}
		
		private function addColumnErrorHandler():void
		{
			trace("add column error")
		}
		
		//INSERT BATCH ROWS
		private function insertCommitHandler(enhanceAdded:Number):void
		{
			trace(enhanceAdded);
			sendNotification(NotificationConstants.STATIONS_ENHANCED_NOTIFICATION)
		}
		
		private function insertRollbackHandler(event:SQLErrorEvent):void
		{
			trace("enhance rollback: " + event.error.details)
		}
		
		
		private function selectAllErrorHandler(event:SQLErrorEvent):void
		{
			trace(event.errorID)
		}
	}
}

