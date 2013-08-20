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
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.ns.common.model.VO.RemoteDatasourceVO;
	
	public class RemoteDatasourceDAO
	{	
		private static const sqlCreate:String='CREATE TABLE IF NOT EXISTS RemoteDatasource ([rd_id] INTEGER PRIMARY KEY AUTOINCREMENT, [rd_name] VARCHAR NOT NULL, [rd_url] VARCHAR NOT NULL, [rd_authRequired] BOOLEAN, [rd_login] VARCHAR, [rd_password] VARCHAR, [rd_fkModule] INT, [rd_logo] VARCHAR, [rd_type] VARCHAR,[rd_format] VARCHAR, FOREIGN KEY ([rd_fkModule]) REFERENCES [Module] ([mod_id]));';
		private static const sqlInsert:String='INSERT INTO RemoteDatasource( rd_name, rd_url, rd_authRequired, rd_login, rd_password, rd_fkModule, rd_logo, rd_type,rd_format ) VALUES ( @rd_name,@rd_url,@rd_authRequired,@rd_login,@rd_password,@rd_fkModule,@rd_logo,@rd_type,@rd_format );';
		private static const sqlSelect:String='SELECT RemoteDatasource.* FROM RemoteDatasource;';
		private static const sqlDelete:String='DELETE FROM RemoteDatasource WHERE RemoteDatasource.rd_id = @rd_id;';
		private static const sqlUpdate:String='UPDATE RemoteDatasource SET rd_name = @rd_name, rd_url = @rd_url, rd_authRequired = @rd_authRequired, rd_login = @rd_login, rd_password = @rd_password, rd_fkModule = @rd_fkModule, rd_logo = @rd_logo, rd_type=@rd_type, rd_format=@rd_format WHERE rd_id = @rd_id;';
		
		private static var instance:RemoteDatasourceDAO;
		public static function getInstance():RemoteDatasourceDAO 
		{
			if( instance == null )
				instance = new RemoteDatasourceDAO( new SingletonLock );
			return instance;
		}
		
	
		public function RemoteDatasourceDAO( lock: SingletonLock) 
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
		
		//UPDATE--------------------------------------------------------------------------------------------
		public function updateRow( rowItem:RemoteDatasourceVO, resultHandler:Function = null, faultHandler:Function = null ):void {
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlUpdate
			setParameters( stmt, [{name:"rd_id", value:rowItem.rd_id},{name:"rd_name", value:rowItem.rd_name}, {name:"rd_url", value:rowItem.rd_url}, {name:"rd_authRequired", value:rowItem.rd_authRequired}, {name:"rd_login", value:rowItem.rd_login}, {name:"rd_password", value:rowItem.rd_password}, {name:"rd_fkModule", value:rowItem.rd_fkModule}, {name:"rd_logo", value:rowItem.rd_logo}, {name:"rd_type", value:rowItem.rd_type}, {name:"rd_format", value:rowItem.rd_format} ] );
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					if ( resultHandler != null ) resultHandler.call( this, rowItem );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		
		
		//SELECT ALL--------------------------------------------------------------------------------------------
		public function selectAll( resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlSelect
			stmt.itemClass = RemoteDatasourceVO;
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//DELETE QUERY------------------------------------------------------------------------
		public function deleteRow( rowItem:RemoteDatasourceVO, resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlDelete
			var params:Array = [ {name:"rd_id", value:rowItem.rd_id} ];
			setParameters( stmt, params );
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					if (resultHandler != null) resultHandler.call(this, rowItem);
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//INSERT--------------------------------------------------------------------------------------------
		public function insertRow( rowItem:RemoteDatasourceVO, resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlInsert
			var params:Array = [{name:"rd_name", value:rowItem.rd_name}, {name:"rd_url", value:rowItem.rd_url}, {name:"rd_authRequired", value:rowItem.rd_authRequired}, {name:"rd_login", value:rowItem.rd_login}, {name:"rd_password", value:rowItem.rd_password}, {name:"rd_fkModule", value:rowItem.rd_fkModule}, {name:"rd_logo", value:rowItem.rd_logo}, {name:"rd_type", value:rowItem.rd_type}, {name:"rd_format", value:rowItem.rd_format} ];
			setParameters( stmt, params );
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				if (!rowItem.rd_id > 0) rowItem.rd_id = stmt.getResult().lastInsertRowID;
				if (resultHandler != null) resultHandler.call(this, rowItem);
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
