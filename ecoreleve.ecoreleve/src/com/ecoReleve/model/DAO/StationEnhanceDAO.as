package com.ecoReleve.model.DAO
{
	/**
	* @author www.comtaste.com
	*/

	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.data.SQLTransactionLockType;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.net.Responder;
	import mx.utils.StringUtil;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class StationEnhanceDAO
	{	
		private static const sqlSelect:String						='SELECT {0}.* FROM {0}';
		private static const sqlSelectDistinct:String				='SELECT distinct {1} FROM {0} ORDER BY {1}';
		private static const sqlSelectDistinctWithCount:String		='SELECT distinct {1},count({1}) as count FROM {0} GROUP BY {1} ORDER BY count desc';
		private static const sqlSelectMinMax:String					='SELECT MIN({1}) as min,MAX({1}) as max FROM {0}'
		
		private static var instance:StationEnhanceDAO;
		public static function getInstance():StationEnhanceDAO
		{
			if( instance == null )
				instance = new StationEnhanceDAO( new SingletonLock );
		
			return instance;
		}
		
	
		public function StationEnhanceDAO( lock: SingletonLock) 
		{
		}
	
		private var sqlConnection:SQLConnection;
		public function getConnection():SQLConnection 
		{
			return sqlConnection;
		}
		public function setConnection(connection:SQLConnection):void 
		{
			// store connection reference
			sqlConnection = connection;
		}
		
		//SELECT --------------------------------------------------------------------------------------------
		public function select(table:String,resultHandler:Function, faultHandler:Function = null,where:String=null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
						
			if (where!=null){
				stmt.text = sqlSelect + ' WHERE ' + where
			}else{
				stmt.text = sqlSelect
			}
			stmt.text=StringUtil.substitute(stmt.text,table)
				
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//SELECT DISTINCT -------------------------------------------------------------------------------------
		public function selectDistinct(table:String,attribute:String,withCount:Boolean,resultHandler:Function, faultHandler:Function = null):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			
			var txt:String;
			if (withCount==true){
				txt=sqlSelectDistinctWithCount
			}else{
				txt=sqlSelectDistinct
			}	
				
			stmt.text=StringUtil.substitute(txt,[table,attribute])

			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//SELECT MIN MAX -------------------------------------------------------------------------------------
		public function selectMinMax(table:String,attribute:String,resultHandler:Function, faultHandler:Function = null):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
				
			stmt.text=StringUtil.substitute(sqlSelectMinMax,[table,attribute])
			
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
