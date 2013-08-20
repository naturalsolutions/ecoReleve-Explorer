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
		private static const sqlSelectDistinct:String				='SELECT distinct @attributeName FROM Station ORDER BY @attributeName';
		private static const sqlSelectDistinctWithCount:String		='SELECT distinct @attributeName,count(@attributeName) as count FROM Station GROUP BY @attributeName ORDER BY count desc';
		private static const sqlSelectMinMax:String					='SELECT MIN(@attributeName) as min,MAX(@attributeName) as max FROM Station'
		
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
		
		private function sqlErrorHandler( event:SQLError ):void {
			Alert.show( event.message, "Error" );
		}
		
	}
}

class SingletonLock {}
