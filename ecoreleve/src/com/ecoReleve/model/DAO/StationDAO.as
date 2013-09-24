package com.ecoReleve.model.DAO
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
	
	import org.ns.common.model.VO.StationVO;
	
	public class StationDAO
	{		
		private static const sqlSelect:String						='SELECT Station.* FROM Station';
		private static const sqlInsert:String						='INSERT INTO Station( sta_name, sta_latitude, sta_longitude, sta_elevation, sta_date, sta_nbIndividual, sta_speciesName, sta_comments, sta_dateY, sta_dateYM, sta_dateYMD, sta_fkQuery, sta_source ) VALUES ( @sta_name,@sta_latitude,@sta_longitude,@sta_elevation,@sta_date,@sta_nbIndividual,@sta_speciesName,@sta_comments,@sta_dateY,@sta_dateYM,@sta_dateYMD,@sta_fkQuery,@sta_source );';
		private static const sqlSelectDistinct:String				='SELECT distinct @attributeName FROM Station ORDER BY @attributeName';
		private static const sqlSelectDistinctWithCount:String		='SELECT distinct @attributeName,count(@attributeName) as count FROM Station GROUP BY @attributeName ORDER BY count desc';
		private static const sqlSelectMinMax:String					='SELECT MIN(@attributeName) as min,MAX(@attributeName) as max FROM Station'
		private static const sqlCount:String						='SELECT COUNT(sta_id) as count FROM Station;';
		private static const sqlDeleteAll:String					='DELETE FROM Station;'
			
		
		private static var instance:StationDAO;
		public static function getInstance():StationDAO 
		{
			if( instance == null )
				instance = new StationDAO( new SingletonLock );
			return instance;
		}
		
	
		public function StationDAO( lock: SingletonLock) 
		{
		}
	
		private var sqlConnection:SQLConnection;
		public function getConnection():SQLConnection 
		{
			return sqlConnection;
		}
		public function setConnection( connection:SQLConnection):void 
		{
			// store connection reference
			sqlConnection = connection;
		}
		
		//BATCH INSERT-----------------------------------------------------------------------------------------------		
		private var commitFunction:Function;
		private var rollbackFunction:Function;
		private var rows:Array;
		private var rowAffected:Number;
		private var q:SQLStatement=null;
		public function insertBatchRow(stations:Array, commitHandler:Function = null, rollbackHandler:Function = null ):void 
		{	
			//define Handler callback
			commitFunction=commitHandler
			rollbackFunction=rollbackHandler
			//get data
			rows=new Array();
			rows=stations;
			//begin batch
			rowAffected=0;
			q=null;
			trace('SEND TRANSACTION');
			CallQuery()
		}
		
		private function CallQuery():void
		{
			if (rows.length==0){
				//end of transaction
				trace('COMMIT');	
				sqlConnection.addEventListener(SQLEvent.COMMIT,commitHandler);
				sqlConnection.commit()	
				return
			}
			if (!q){
				//begin transaction
				sqlConnection.begin(SQLTransactionLockType.IMMEDIATE);
				q = new SQLStatement();
				q.addEventListener(SQLEvent.RESULT,onQueryResult);
				q.addEventListener(SQLErrorEvent.ERROR,onQueryError);
				q.sqlConnection = sqlConnection;
				q.text = sqlInsert
			}
			var rowItem:StationVO=rows.shift() as StationVO
			q.clearParameters();
			var params:Array = [ {name:"sta_name", value:rowItem.sta_name}, {name:"sta_latitude", value:rowItem.sta_latitude}, {name:"sta_longitude", value:rowItem.sta_longitude}, {name:"sta_elevation", value:rowItem.sta_elevation}, {name:"sta_date", value:rowItem.sta_date}, {name:"sta_nbIndividual", value:rowItem.sta_nbIndividual}, {name:"sta_speciesName", value:rowItem.sta_speciesName}, {name:"sta_comments", value:rowItem.sta_comments}, {name:"sta_dateY", value:rowItem.sta_dateY}, {name:"sta_dateYM", value:rowItem.sta_dateYM}, {name:"sta_dateYMD", value:rowItem.sta_dateYMD}, {name:"sta_fkQuery", value:rowItem.sta_fkQuery}, {name:"sta_source", value:rowItem.sta_source} ];
			setParameters( q, params );
			q.execute();
			rowAffected+=1;
		}
		
		private function onQueryResult(event:SQLEvent):void 
		{
			//q.removeEventListener(SQLEvent.RESULT,onQueryResult);
			CallQuery();
		}
		
		private function onQueryError(error:SQLErrorEvent):void 
		{
			//q.removeEventListener(SQLErrorEvent.ERROR,onQueryError);
			trace('ROLLBACK');
			trace(error.error.details)
			// ROLLBACK ENTIRE TRANSACTION
			if (sqlConnection.inTransaction) {
				sqlConnection.addEventListener(SQLEvent.ROLLBACK,rollbackHandler);
				sqlConnection.rollback();
			}
		}
		
		private function commitHandler(event:SQLEvent):void 
		{
			sqlConnection.removeEventListener(SQLEvent.COMMIT,commitHandler);
			if (commitFunction != null) commitFunction.call(this,rowAffected);
		}
		
		private function rollbackHandler(event:SQLEvent):void 
		{
			sqlConnection.removeEventListener(SQLEvent.ROLLBACK,rollbackHandler);
			if (rollbackFunction != null) rollbackFunction.call(this);
		}
		
		//SELECT --------------------------------------------------------------------------------------------
		public function select(resultHandler:Function, faultHandler:Function = null,where:String=null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
						
			if (where!=null){
				stmt.text = sqlSelect + ' WHERE ' + where
			}else{
				stmt.text = sqlSelect
			}
			
			stmt.itemClass = StationVO;
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//SELECT DISTINCT -------------------------------------------------------------------------------------
		public function selectDistinct(attribute:String,withCount:Boolean,resultHandler:Function, faultHandler:Function = null):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			
			var txt:String;
			if (withCount==true){
				txt=sqlSelectDistinctWithCount
			}else{
				txt=sqlSelectDistinct
			}	
			
			var myRegExp:RegExp=new RegExp('@attributeName','g')
			txt=txt.replace(myRegExp,attribute)
				
			stmt.text = txt

			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//SELECT MIN MAX -------------------------------------------------------------------------------------
		public function selectMinMax(attribute:String,resultHandler:Function, faultHandler:Function = null):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			var txt:String=sqlSelectMinMax
			
			var myRegExp:RegExp=new RegExp('@attributeName','g')
			txt=txt.replace(myRegExp,attribute)
				
			stmt.text = txt
			
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
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
			stmt.itemClass = StationVO;
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//COUNT--------------------------------------------------------------------------------------------
		public function countAll( resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlCount
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					resultHandler.call( this, Number(stmt.getResult().data[0].count));
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//DELETE ALL------------------------------------------------------------------------
		public function deleteAll(resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlDeleteAll;
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					if (resultHandler != null) resultHandler.call(this);
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
