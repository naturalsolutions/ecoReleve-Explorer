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
	
	import org.ns.common.model.VO.ModuleVO;
	
	public class ModuleDAO
	{	
		private static const sqlCreate:String='CREATE TABLE IF NOT EXISTS Module ([mod_id] INTEGER PRIMARY KEY AUTOINCREMENT, [mod_name] VARCHAR NOT NULL, [mod_url] VARCHAR NOT NULL, [mod_type] VARCHAR NOT NULL);';
		private static const sqlInsert:String='INSERT INTO Module( mod_name, mod_url, mod_type ) VALUES ( @mod_name,@mod_url,@mod_type );';
		private static const sqlSelect:String='SELECT Module.* FROM Module;';
		
		private static var instance:ModuleDAO;
		public static function getInstance():ModuleDAO 
		{
			if( instance == null )
				instance = new ModuleDAO( new SingletonLock );
			return instance;
		}
		
	
		public function ModuleDAO( lock: SingletonLock) 
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
		
		//SELECT ALL--------------------------------------------------------------------------------------------
		public function selectAll( resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlSelect
			stmt.itemClass = ModuleVO;
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//INSERT--------------------------------------------------------------------------------------------
		public function insertRow( rowItem:ModuleVO, resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlInsert
			var params:Array = [ {name:"mod_name", value:rowItem.mod_name}, {name:"mod_url", value:rowItem.mod_url}, {name:"mod_type", value:rowItem.mod_type} ];
			setParameters( stmt, params );
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					if (!rowItem.mod_id > 0) rowItem.mod_id = stmt.getResult().lastInsertRowID;
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
