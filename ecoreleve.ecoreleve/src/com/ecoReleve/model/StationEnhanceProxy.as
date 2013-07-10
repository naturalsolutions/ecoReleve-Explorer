package com.ecoReleve.model
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DAO.StationEnhanceDAO;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.StationVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class StationEnhanceProxy extends FabricationProxy
	{
		public static const NAME:String = "StationEnhanceProxy";	
		
		public var stations:ArrayCollection=new ArrayCollection();
		public var fieldList:ArrayCollection=new ArrayCollection();
		
		private static var tableToUse:String='Station'
		private var _where:String=null
		public function StationEnhanceProxy()
		{
			super(NAME);	
		}
		
		private function setTableToUse(conn:SQLConnection):void
		{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection=conn;
			stmt.sqlConnection.addEventListener(SQLEvent.SCHEMA, handleSchema)	
			stmt.sqlConnection.loadSchema(); 		
		}
		
		private function handleSchema(e:SQLEvent):void		
		{		
			var result:SQLSchemaResult = (e.target as SQLConnection).getSchemaResult();
			
			tableToUse='Station'
			
			for each(var table:SQLTableSchema in result.tables){
				if (table.name=='Enhance'){
					tableToUse='Station_enhance'
				}
			}
			
			var dao:StationEnhanceDAO=StationEnhanceDAO.getInstance()
			dao.setConnection(e.target as SQLConnection)
			dao.select(tableToUse,selectResultHandler,selectErrorHandler,_where)		
		}
		
		
		public function selectStations(conn:SQLConnection,where:String=null):void
		{
			_where=where;
			setTableToUse(conn);					
		}
		
		public function selectDistinctValue(attribute:String,conn:SQLConnection):void
		{
			var dao:StationEnhanceDAO=StationEnhanceDAO.getInstance()
			dao.setConnection(conn)
			dao.selectDistinct(tableToUse,attribute,true,selectDistinctResultHandler,selectErrorHandler)							
		}
		
		public function selectMinMax(attribute:String,conn:SQLConnection):void
		{
			var dao:StationEnhanceDAO=StationEnhanceDAO.getInstance()
			dao.setConnection(conn)
			dao.selectMinMax(tableToUse,attribute,selectMinMaxResultHandler,selectErrorHandler)							
		}
		
		public function getListField(fieldType:String=null):Array
		{
			var resultArray:Array=new Array;
			
			if (fieldType==null){
				resultArray=getFieldName(fieldList.source);
			}else{
				//create array with property value
				resultArray=getFieldName(findInCollection(fieldList,findFunction('property',fieldType)));
				//add NONE value
				resultArray.unshift("NONE")
			}
			
			return resultArray;
		}
		
		
		//HANDLERS
		private function structureResultHandler(items:ArrayCollection):void
		{
			trace(items)
		}
		
		//SELECT 
		private function selectResultHandler(items:ArrayCollection):void
		{
			stations.removeAll()
			
			//create station for each object with dynamic property(table enhance)
			var obj:Object
			var station:StationVO;
			for each(obj in items){
				station=new StationVO;
				for (var p:String in obj) {
					station[p]=obj[p]
				}
				stations.addItem(station)
			}
			
			fieldList=new ArrayCollection()
			fieldList=createProperties()
				
			sendNotification(NotificationConstants.STATIONS_ADDED_NOTIFICATION,stations);
		}
		
		private function selectDistinctResultHandler(items:ArrayCollection):void
		{
			sendNotification(NotificationConstants.ATTRIBUTE_DISTINCT_ADDED_NOTIFICATION,items);
		}
		
		private function selectMinMaxResultHandler(items:ArrayCollection):void
		{
			sendNotification(NotificationConstants.ATTRIBUTE_MINMAX_ADDED_NOTIFICATION,items);
		}
		
		private function selectErrorHandler(event:SQLErrorEvent):void
		{
			trace("station select error: " + event.error.details)
		}
		

		private function createProperties():ArrayCollection
		{
			var arrCol:ArrayCollection=new ArrayCollection();
			
			//create attributes
			if (stations.length>0){
				var classInfo:XML = describeType(stations[0]);
				var v:XML;
				var obj:Object;
				var type:String;
				
				//add VO definition property
				for each (v in classInfo..accessor) {
					obj=new Object();
					obj.propertyName=String(v.attribute('name'));
					type=String(v.attribute('type'));
					
					switch (type){
						case 'String':
							obj.property='class'
							break;
						case 'int':        //nb individual
							obj.property='ordonable'
							break;
						case 'Number':      //lat,lon ele
							obj.property='nothing'
							break;
						case 'Date':
							obj.property='nothing'
							break;
					}
					
					obj.propertyType=type;
					arrCol.addItem(obj)
				}
				
				//add dynamic property with first station
				for (var prop:String in stations[0]){
					obj=new Object()
					obj.propertyName=prop
					obj.propertyType='dynamic'
					obj.property='class'
					arrCol.addItem(obj)
				}
			}
			
			return arrCol
		}
		
		private function findInCollection(c:ArrayCollection, findFunction:Function):Array
		{
			var matches : Array = c.source.filter( findFunction );
			return matches;
		}
		
		private function findFunction(propertyName:String,propertyValue:*):Function
		{
			return function( element : *, index : int, array : Array ) : Boolean
			{
				return element[propertyName] == propertyValue;
			}
		}
		
		private function getFieldName(arrFields:Array):Array
		{
			var arr:Array=new Array()
			
			var obj:Object;
			for each (obj in arrFields){
				arr.push(obj.propertyName)
			}				
			return arr;
		}
	
	}
}