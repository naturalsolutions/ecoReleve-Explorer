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
	import mx.utils.StringUtil;
	
	public class EnhanceDAO
	{	
		private static const sqlCreateTable:String	='CREATE TABLE IF NOT EXISTS Enhance ([enh_id] INTEGER PRIMARY KEY AUTOINCREMENT);';
		private static const sqlDropTable:String	='DROP TABLE IF EXISTS Enhance;';
		private static const sqlAddColumn:String  	='ALTER TABLE Enhance ADD COLUMN {0} TEXT;';
		private static const sqlInsert:String		='INSERT INTO Enhance ({0}) VALUES ({1});';
		
		private static var instance:EnhanceDAO;
		public static function getInstance():EnhanceDAO 
		{
			if( instance == null )
				instance = new EnhanceDAO( new SingletonLock );
			return instance;
		}
		
	
		public function EnhanceDAO( lock: SingletonLock) 
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
			stmt.text = sqlCreateTable
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				if (resultHandler != null) resultHandler.call(this);
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//DROP TABLE--------------------------------------------------------------------------------------------
		public function dropTable( resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlDropTable
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					if (resultHandler != null) resultHandler.call(this);
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//BATCH INSERT COLUMNS----------------------------------------------------------------------------------------------		
		private var colsCommitFunction:Function;
		private var colsRollbackFunction:Function;
		private var cols:Array;
		private var colAffected:Number;
		private var colSQL:SQLStatement=null;
		public function insertBatchCol(items:Array, commitHandler:Function = null, rollbackHandler:Function = null ):void 
		{	
			//define Handler callback
			colsCommitFunction=commitHandler
			colsRollbackFunction=rollbackHandler
			//get data
			cols=new Array();
			cols=items;
			//begin batch
			colAffected=0;
			colSQL=null;
			trace('SEND TRANSACTION');
			colQuery()
		}
		
		private function colQuery():void
		{
			if (cols.length==0){
				//end of transaction
				trace('COMMIT');	
				sqlConnection.addEventListener(SQLEvent.COMMIT,colCommitHandler);
				sqlConnection.commit()	
				return
			}
			if (!colSQL){
				//begin transaction
				sqlConnection.begin(SQLTransactionLockType.IMMEDIATE);
				colSQL = new SQLStatement();
				colSQL.addEventListener(SQLEvent.RESULT,colQueryResult);
				colSQL.addEventListener(SQLErrorEvent.ERROR,colQueryError);
				colSQL.sqlConnection = sqlConnection;
			}		
			
			var colItem:String=cols.shift() as String
			var sql:String=sqlAddColumn
			colSQL.text = StringUtil.substitute(sql,"'" + colItem + "'");
			
			colSQL.execute();
			colAffected+=1;
		}
		
		private function colQueryResult(event:SQLEvent):void 
		{
			colQuery();
		}
		
		private function colQueryError(error:SQLErrorEvent):void 
		{
			trace('ROLLBACK');
			trace(error.error.details)
			// ROLLBACK ENTIRE TRANSACTION
			if (sqlConnection.inTransaction) {
				sqlConnection.addEventListener(SQLEvent.ROLLBACK,colRollbackHandler);
				sqlConnection.rollback();
			}
		}
		
		private function colCommitHandler(event:SQLEvent):void 
		{
			sqlConnection.removeEventListener(SQLEvent.COMMIT,colCommitHandler);
			if (colsCommitFunction != null) colsCommitFunction.call(this,colAffected);
		}
		
		private function colRollbackHandler(event:SQLEvent):void 
		{
			sqlConnection.removeEventListener(SQLEvent.ROLLBACK,colRollbackHandler);
			if (colsRollbackFunction != null) colsRollbackFunction.call(this);
		}

		//BATCH INSERT-----------------------------------------------------------------------------------------------		
		private var rowsCommitFunction:Function;
		private var rowsRollbackFunction:Function;
		private var rows:Array;
		private var rowAffected:Number;
		private var rowSQL:SQLStatement=null;
		public function insertBatchRow(items:Array, commitHandler:Function = null, rollbackHandler:Function = null ):void 
		{	
			//define Handler callback
			rowsCommitFunction=commitHandler
			rowsRollbackFunction=rollbackHandler
			//get data
			rows=new Array();
			rows=items;
			//begin batch
			rowAffected=0;
			rowSQL=null;
			trace('SEND TRANSACTION');
			rowQuery()
		}
		
		private function rowQuery():void
		{
			if (rows.length==0){
				//end of transaction
				trace('COMMIT');	
				sqlConnection.addEventListener(SQLEvent.COMMIT,rowCommitHandler);
				sqlConnection.commit()	
				return
			}
			if (!rowSQL){
				//begin transaction
				sqlConnection.begin(SQLTransactionLockType.IMMEDIATE);
				rowSQL = new SQLStatement();
				rowSQL.addEventListener(SQLEvent.RESULT,rowQueryResult);
				rowSQL.addEventListener(SQLErrorEvent.ERROR,rowQueryError);
				rowSQL.sqlConnection = sqlConnection;
			}
			var rowItem:Object=rows.shift() as Object
			rowSQL.clearParameters();
			
			var strAttributes:String=''
			var strValues:String=''
			for (var p:String in rowItem) {
				strAttributes +="'" + p + "',";
				strValues += "'" + rowItem[p] + "',";
			}
			strAttributes=strAttributes.slice(0,strAttributes.lastIndexOf(','))
			strValues=strValues.slice(0,strValues.lastIndexOf(','))
			
			var sql:String=sqlInsert
			rowSQL.text = StringUtil.substitute(sql,[strAttributes,strValues]);
				
			//var params:Array = [ {name:"attributes", value:strAttributes}, {name:"values", value:strValues}];
			//setParameters( rowSQL, params );
			rowSQL.execute();
			rowAffected+=1;
		}
		
		private function rowQueryResult(event:SQLEvent):void 
		{
			//rowSQL.removeEventListener(SQLEvent.RESULT,rowQueryResult);
			rowQuery();
		}
		
		private function rowQueryError(error:SQLErrorEvent):void 
		{
			//rowSQL.removeEventListener(SQLErrorEvent.ERROR,rowQueryError);
			trace('ROLLBACK');
			trace(error.error.details)
			// ROLLBACK ENTIRE TRANSACTION
			if (sqlConnection.inTransaction) {
				sqlConnection.addEventListener(SQLEvent.ROLLBACK,rowRollbackHandler);
				sqlConnection.rollback();
			}
		}
		
		private function rowCommitHandler(event:SQLEvent):void 
		{
			sqlConnection.removeEventListener(SQLEvent.COMMIT,rowCommitHandler);
			if (rowsCommitFunction != null) rowsCommitFunction.call(this,rowAffected);
		}
		
		private function rowRollbackHandler(event:SQLEvent):void 
		{
			sqlConnection.removeEventListener(SQLEvent.ROLLBACK,rowRollbackHandler);
			if (rowsRollbackFunction != null) rowsRollbackFunction.call(this);
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
