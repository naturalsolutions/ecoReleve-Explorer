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
	
	import org.ns.common.model.VO.QueryVO;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class QueryDAO
	{	
		//TO DO
		//private static const sqlInsertMyLastMonthQuery:String=	'INSERT INTO QUERY( QueryMinDate, QueryMaxDate, QueryFormat, QueryDataOwner, QueryName ) VALUES (julianday("now","start of month"),julianday("now"),"flat","my","my last month data");'
		
		private static const sqlCreate:String				='CREATE TABLE IF NOT EXISTS Query ([qry_id] INTEGER PRIMARY KEY AUTOINCREMENT, [qry_minDate] DATE NOT NULL, [qry_maxDate] DATE NOT NULL, [qry_format] VARCHAR NOT NULL, [qry_idTaxon] INT, [qry_topicFr] CHAR, [qry_isTaxonFather] BOOLEAN DEFAULT(0), [qry_minLat] NUMERIC NOT NULL DEFAULT(- 90), [qry_maxLat] NUMERIC NOT NULL DEFAULT(90), [qry_minLon] NUMERIC NOT NULL DEFAULT(- 180), [qry_maxLon] NUMERIC NOT NULL DEFAULT(180), [qry_dataOwner] VARCHAR NOT NULL, [qry_maxResult] NUMERIC NOT NULL DEFAULT(2500), [qry_name] TEXT NOT NULL,[qry_persist] BOOLEAN DEFAULT(0));';
		private static const sqlInsert:String				='INSERT INTO Query( qry_minDate, qry_maxDate, qry_format, qry_idTaxon, qry_topicFr, qry_isTaxonFather, qry_minLat, qry_maxLat, qry_minLon, qry_maxLon, qry_dataOwner, qry_maxResult, qry_name,qry_persist ) VALUES ( @qry_minDate,@qry_maxDate,@qry_format,@qry_idTaxon,@qry_topicFr,@qry_isTaxonFather,@qry_minLat,@qry_maxLat,@qry_minLon,@qry_maxLon,@qry_dataOwner,@qry_maxResult,@qry_name,@qry_persist );';
		private static const sqlUpdate:String				='UPDATE Query SET qry_minDate = @qry_minDate, qry_maxDate = @qry_maxDate, qry_format = @qry_format, qry_idTaxon = @qry_idTaxon, qry_topicFr = @qry_topicFr, qry_isTaxonFather = @qry_isTaxonFather, qry_minLat = @qry_minLat, qry_maxLat = @qry_maxLat, qry_minLon = @qry_minLon, qry_maxLon = @qry_maxLon, qry_dataOwner = @qry_dataOwner, qry_maxResult = @qry_maxResult, qry_name = @qry_name, qry_persist =@qry_persist  WHERE qry_id = @qry_id;';
		private static const sqlSelect:String				='SELECT Query.* FROM Query;';
		private static const sqlDelete:String				='DELETE FROM Query WHERE Query.qry_id = @qry_id;';
		private static const sqlUnPersistentDelete:String	='DELETE FROM Query WHERE Query.qry_persist = 0;';
		private static const sqlCount:String				='SELECT COUNT(qry_id) as count FROM Query;';
		private static const sqlUsed:String					='SELECT Query.* from Query INNER JOIN Station ON Query.qry_id=Station.sta_fkQuery GROUP BY QUERY.qry_id';
		
		private static var instance:QueryDAO;
		public static function getInstance():QueryDAO 
		{
			if( instance == null )
				instance = new QueryDAO( new SingletonLock );
			return instance;
		}
		
	
		public function QueryDAO( lock: SingletonLock) 
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
			stmt.itemClass = QueryVO;
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//USED QUERY (join with Station)-------------------------------------------------------------------
		public function used( resultHandler:Function, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlUsed
			stmt.itemClass = QueryVO;
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
		
		//INSERT--------------------------------------------------------------------------------------------
		public function insertRow( rowItem:QueryVO, resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlInsert
			var params:Array = [ {name:"qry_minDate", value:rowItem.qry_minDate}, {name:"qry_maxDate", value:rowItem.qry_maxDate}, {name:"qry_format", value:rowItem.qry_format}, {name:"qry_idTaxon", value:rowItem.qry_idTaxon}, {name:"qry_topicFr", value:rowItem.qry_topicFr}, {name:"qry_isTaxonFather", value:rowItem.qry_isTaxonFather}, {name:"qry_minLat", value:rowItem.qry_minLat}, {name:"qry_maxLat", value:rowItem.qry_maxLat}, {name:"qry_minLon", value:rowItem.qry_minLon}, {name:"qry_maxLon", value:rowItem.qry_maxLon}, {name:"qry_dataOwner", value:rowItem.qry_dataOwner}, {name:"qry_maxResult", value:rowItem.qry_maxResult}, {name:"qry_name", value:rowItem.qry_name},{name:"qry_persist", value:rowItem.qry_persist} ];
			setParameters( stmt, params );
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				if (!rowItem.qry_id > 0) rowItem.qry_id = stmt.getResult().lastInsertRowID;
				if (resultHandler != null) resultHandler.call(this, rowItem);
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//DELETE QUERY------------------------------------------------------------------------
		public function deleteRow( rowItem:QueryVO, resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlDelete
			var params:Array = [ {name:"qry_id", value:rowItem.qry_id} ];
			setParameters( stmt, params );
			stmt.addEventListener( SQLEvent.RESULT,
			function ( event:SQLEvent ):void {
				if (resultHandler != null) resultHandler.call(this, rowItem);
			});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//DELETE UNPERSISTENT QUERY------------------------------------------------------------------------
		public function deleteUnpersistentQuery(resultHandler:Function = null, faultHandler:Function = null ):void 
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = sqlUnPersistentDelete
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					if (resultHandler != null) resultHandler.call(this);
				});
			stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );
			stmt.execute();
		}
		
		//UPDATE QUERY------------------------------------------------------------------------
		public function updateRow( rowItem:QueryVO, resultHandler:Function = null, faultHandler:Function = null ):void {
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text =sqlUpdate
			setParameters( stmt, [ {name:"qry_id", value:rowItem.qry_id}, {name:"qry_minDate", value:rowItem.qry_minDate}, {name:"qry_maxDate", value:rowItem.qry_maxDate}, {name:"qry_format", value:rowItem.qry_format}, {name:"qry_idTaxon", value:rowItem.qry_idTaxon}, {name:"qry_topicFr", value:rowItem.qry_topicFr}, {name:"qry_isTaxonFather", value:rowItem.qry_isTaxonFather}, {name:"qry_minLat", value:rowItem.qry_minLat}, {name:"qry_maxLat", value:rowItem.qry_maxLat}, {name:"qry_minLon", value:rowItem.qry_minLon}, {name:"qry_maxLon", value:rowItem.qry_maxLon}, {name:"qry_dataOwner", value:rowItem.qry_dataOwner}, {name:"qry_maxResult", value:rowItem.qry_maxResult}, {name:"qry_name", value:rowItem.qry_name}, {name:"qry_persist", value:rowItem.qry_persist} ] );
			stmt.addEventListener( SQLEvent.RESULT,
				function ( event:SQLEvent ):void {
					if ( resultHandler != null ) resultHandler.call( this, rowItem );
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
