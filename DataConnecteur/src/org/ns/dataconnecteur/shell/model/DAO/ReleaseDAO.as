package org.ns.dataconnecteur.shell.model.DAO
{
	/**
	* @author www.comtaste.com
	*/

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTransactionLockType;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.net.Responder;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class ReleaseDAO
	{		
		private static const sqlCreate:String						='CREATE TABLE IF NOT EXISTS [Release] (rel_number CHAR);';
		private static const sqlSelect:String						='SELECT Release.rel_number FROM Release;';
		private static const sqlUpdate:String						='UPDATE Release SET rel_number=';
	
		private static var instance:ReleaseDAO;
		public static function getInstance():ReleaseDAO 
		{
			if( instance == null )
				instance = new ReleaseDAO( new SingletonLock );
			return instance;
		}
		
	
		public function ReleaseDAO( lock: SingletonLock) 
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
			// try construct table on Database any time a new connection is submitted
			if(sqlConnection.connected && initializeTable){
				createTable();				
			}
		}
	
		//CREATE TABLE--------------------------------------------------------------------------------------------
		public function createTable( resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlCreate
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				if (resultHandler != null) resultHandler.call(this);
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//SELECT -------------------------------------------------------------------------------------
		public function select(resultHandler:Function, faultHandler:Function = null):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			
			stmt.text = sqlSelect
			
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this,stmt.getResult().data[0]);
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}

		//INSERT--------------------------------------------------------------------------------------------
		public function updateReleaseNumber(numberRelease:String, resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlUpdate + "'" + numberRelease + "'"
			//var params:Array = [ {number:numberRelease}];
			//setParameters( stmt, params );
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				if (resultHandler != null) resultHandler.call(this,numberRelease);
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}

		
		private function setParameters( stmt:SQLStatement, params:Array ):void 
		{
			var param:Object;
			for ( var i:int = 0; i < params.length; i++ ) {
				param = params[i];
				stmt.parameters[ '@' + param.name ] = param.value;
			}
		}
		
		private function sqlErrorHandler( event:SQLError ):void {
			Alert.show( event.message, "Error" );
		}
		
	}
}

class SingletonLock {}
