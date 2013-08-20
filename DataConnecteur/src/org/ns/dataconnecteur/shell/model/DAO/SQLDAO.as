package org.ns.dataconnecteur.shell.model.DAO
{
	/**
	* @author www.comtaste.com
	*/
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.net.Responder;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.VO.LocalConnectorVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class SQLDAO
	{	
		private static const sqlQueryUsedInStation:String			='SELECT count(Station.sta_fkQuery) as countSta,Query.* from Query INNER JOIN Station ON Query.qry_id=Station.sta_fkQuery GROUP BY Query.qry_id';
		private static const sqlResumeSourceData:String				='SELECT count(sta_source) as count, sta_source FROM Station GROUP BY sta_source'
		private static const sqlStationsJoinQuery:String 			='SELECT Station.sta_iD as ID,Station.sta_source as source,Query.qry_name as queryName FROM Station LEFT OUTER JOIN QUERY ON Query.qry_id= Station.sta_fkQuery';
		private static const sqlModuleJoinRemoteDatasource:String	='SELECT * FROM Module INNER JOIN RemoteDatasource ON RemoteDatasource.rd_fkModule=Module.mod_id';
		private static const sqlModuleJoinLocalDatasource:String	='SELECT * FROM Module INNER JOIN LocalDatasource ON LocalDatasource.ld_fkModule=Module.mod_id';

		private static var instance:SQLDAO;
		public static function getInstance():SQLDAO 
		{
			if( instance == null )
				instance = new SQLDAO( new SingletonLock );
			return instance;
		}
		
	
		public function SQLDAO( lock: SingletonLock) 
		{
		}
	
		private var sqlConnection:SQLConnection;
		public function getConnection():SQLConnection 
		{
			return sqlConnection;
		}
		public function setConnection( connection:SQLConnection, initializeTable:Boolean = false ):void 
		{
			// store connection reference
			sqlConnection = connection;
		}
		
		//selectQueryUsedInStation--------------------------------------------------------------------------------------------
		public function selectQueryUsedInStation(resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlQueryUsedInStation
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//selectResumeSourceData--------------------------------------------------------------------------------------------
		public function selectResumeSourceData(resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlResumeSourceData
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//selectModuleJoinRemoteDatasource--------------------------------------------------------------------------------------------
		public function selectModuleJoinRemoteDatasource(resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlModuleJoinRemoteDatasource
			stmt.itemClass=RemoteConnectorVO;
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//selectModuleJoinLocalDatasource--------------------------------------------------------------------------------------------
		public function selectModuleJoinLocalDatasource(resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlModuleJoinLocalDatasource
			stmt.itemClass=LocalConnectorVO;
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//selectStationsWithDatasource--------------------------------------------------------------------------------------------
		public function selectStationsJoinQuery(resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlStationsJoinQuery
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		private function sqlErrorHandler( event:SQLError ):void {
			Alert.show( event.message, "Error" );
		}
		
	}
}

class SingletonLock {}
