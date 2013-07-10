package org.ns.OdataImportModule.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.collections.XMLListCollection;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	
	import org.ns.OdataImportModule.controller.*;
	import org.ns.OdataImportModule.model.VO.QueryOdataVO;
	import org.ns.OdataImportModule.model.proxy.MetadataProxy;
	import org.ns.OdataImportModule.view.components.odataWizard;
	import org.ns.OdataImportModule.view.components.steps.Step3;
	import org.ns.common.utils.DateUtils;
	import org.ns.genericComponents.geonames.VO.ToponymVO;
	import org.ns.genericComponents.geonames.event.ToponymEvent;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.components.DropDownList;
	import spark.components.TitleWindow;
	import spark.events.IndexChangeEvent;
	
	public class Step3Mediator extends FlexMediator
	{
		//mediator NAME
		public static const NAME:String = "Step3Mediator";
		public var minDateWatcher:ChangeWatcher;
		public var maxDateWatcher:ChangeWatcher;
		public var minLatWatcher:ChangeWatcher;
		public var maxLatWatcher:ChangeWatcher;
		public var minLonWatcher:ChangeWatcher;
		public var maxLonWatcher:ChangeWatcher;
		
		private var dataModel:*
		private var toponym:ToponymVO;
			
		public function Step3Mediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
		} 		
		
		override public function onRegister():void 
		{
			super.onRegister();	
			
			step.addEventListener("ADD_WHAT_QUERY",HandleAddWhatQueryClick)
			step.addEventListener("TEST_QUERY",HandleTestQueryClick)
			step.addEventListener("CHANGE_EXTENT",HandleSliderChange)
			step.addEventListener("CHANGE_INTERVAL",HandleDateIntervalChange)
			step.addEventListener("GEOSEARCH_CREATED",HandleGeoSearchCreated)
			
				
			//set watchers
			minDateWatcher=ChangeWatcher.watch(step,['minDate'],HandleMinDateChange,true,true)
			maxDateWatcher=ChangeWatcher.watch(step,['maxDate'],HandleMaxDateChange,true,true)
			
			minLatWatcher=ChangeWatcher.watch(step,['minLat'],HandleMinLatChange,true,true)
			maxLatWatcher=ChangeWatcher.watch(step,['maxLat'],HandleMaxLatChange,true,true)
			minLonWatcher=ChangeWatcher.watch(step,['minLon'],HandleMinLonChange,true,true)
			maxLonWatcher=ChangeWatcher.watch(step,['maxLon'],HandleMaxLonChange,true,true)
	
			//queries change event Handler
			step.queries.addEventListener(CollectionEvent.COLLECTION_CHANGE,HandleQueriesChange)	
				
		}

		
		//RESPOND
		public function respondToStep2Next(note:INotification):void
		{
			dataModel=note.getBody()

			//get all entities
			var linkedEntities:XMLList=new XMLList
			var entitiy:XMLList=new XMLList
			entitiy+=dataModel.ENTITY
			linkedEntities+=dataModel.ENTITY_LINKED	
	
			//get property list
			var pxyMetadata:MetadataProxy=retrieveProxy(MetadataProxy.NAME) as MetadataProxy;	
			var properties:XMLListCollection=new XMLListCollection(pxyMetadata.GetPropertyList(entitiy,linkedEntities))
			var propertiesDate:XMLListCollection=new XMLListCollection(pxyMetadata.GetPropertyList(entitiy,linkedEntities,"DateTime"))
			var propertiesDouble:XMLListCollection=new XMLListCollection(pxyMetadata.GetPropertyList(entitiy,linkedEntities,"Double"))

			step.properties.removeAll();
			step.properties.refresh();	
			step.properties=properties;
			
			step.propertiesDate.removeAll();
			step.propertiesDate.refresh();	
			step.propertiesDate=propertiesDate;
			
			step.propertiesDouble.removeAll();
			step.propertiesDouble.refresh();	
			step.propertiesDouble=propertiesDouble;
		}
		
		public function respondToStationsCounted(note:INotification):void
		{
			var tot:Number=note.getBody() as Number
			step.strResultTest.text=String(tot) + ' station(s)'
			step.strResultTest.visible=true
			step.pgTest.visible=false
				
			if (tot!=0){
				step.isValid=true;
			} else{
				step.isValid=false;
			}
		}
		
		
		public function respondToStationsCountedError(note:INotification):void
		{
			step.strResultTest.text='Error==> the query is not valid'
			step.strResultTest.visible=true
			step.pgTest.visible=false
			step.isValid=false;
		}
		
		//REACTION
		
		private function HandleGeoSearchCreated(event:Event):void
		{
			step.geoSearch.addEventListener(ToponymEvent.COMPLETE,HandleGeonameResult);
			step.geoSearch.addEventListener(ToponymEvent.CLEAR,HandleGeonameClear);
		}
		private function HandleGeonameResult(event:ToponymEvent):void
		{
			toponym=new ToponymVO();
			toponym=event.data as ToponymVO
			
			majExtent()
			
			step.slider.value=0;
			step.slider.enabled=true;

		}
		
		private function HandleGeonameClear(event:ToponymEvent):void
		{
			step.minLat="-90";	
			step.maxLat="90";
			step.minLon="-180";
			step.maxLon="180";
			
			step.txtArea.text=''
			step.slider.value=0;
			step.slider.enabled=false;
		}
		
		private function HandleSliderChange(event:Event):void
		{
			majExtent()
		}
		
		private function majExtent():void
		{
			var delta:Number=step.slider.value + 0.01
			
			var minLat:Number=Math.max(-90,Math.min(toponym.lat,toponym.lat - delta)) 
			step.minLat=String(int(minLat*100)/100)	
			
			var maxLat:Number=Math.min(90,Math.max(toponym.lat,toponym.lat + delta))			
			step.maxLat=String(int(maxLat*100)/100)
				
			var minLon:Number=Math.max(-180,Math.min(toponym.lng,toponym.lng - delta))
			step.minLon=String(int(minLon*100)/100)
			
			var maxLon:Number=Math.min(180,Math.max(toponym.lng,toponym.lng + delta))
			step.maxLon=String(int(maxLon*100)/100)
			
			var d1:int=calculDistance(Number(step.minLat),Number(step.minLon),Number(step.maxLat),Number(step.minLon))	
			var d2:int=calculDistance(Number(step.minLat),Number(step.minLon),Number(step.minLat),Number(step.maxLon))	
				
			step.txtArea.text=String(d1) + " km x " + String(d2) + " km"

		}
		
		//d = R * (Pi/2 - ArcSin( sin(destLat) * sin(sourceLat) + cos(destLong - sourceLong) * cos(destLat) * cos(sourceLat)))
		private function calculDistance(sourceLat:Number,sourceLong:Number,destLat:Number,destLong:Number):Number
		{
			var d:Number;
			
			var R:Number=6378;
			
			sourceLat=degToRad(sourceLat)
			sourceLong=degToRad(sourceLong)
			destLat=degToRad(destLat)
			destLong=degToRad(destLong)
			
			d = Math.acos( Math.sin(sourceLat) * Math.sin(destLat) + Math.cos(sourceLat) * Math.cos(destLat) * Math.cos(sourceLong-destLong) );
			d = d * R;
			
			//d=R*(Math.PI/2 - Math.asin(Math.sin(destLat) * Math.sin(sourceLat) + Math.cos(destLong-destLat) * Math.cos(destLat) * Math.cos(sourceLat)))
			
			return d
		}
		
		private function degToRad(degrees:Number):Number
		{
			// Degrees to Radians
			var radians:Number = degrees * Math.PI / 180
			
			return radians
		}
		
		private function radToDeg(radians:Number):Number
		{
			// Radians to Degrees
			var degree:Number = radians * 180 / Math.PI	
			
			return degree
		}
		
		private  function HandleAddWhatQueryClick(event:Event):void
		{
			var q:QueryOdataVO=new QueryOdataVO()
			var xml:XML=step.lstField.selectedItem	
			q.qry_field=xml.attribute('Name')
			q.qry_type=xml.attribute('Type')
			q.qry_operator =(step.lstOperator.selectedItem as Object).value
			
			switch (q.qry_type){
				case "Edm.DateTime":
					var strDate:String=DateUtils.CastDateToString(step.dfDateValue.selectedDate,"YYYY-MM-DD") + "T00:00:00";
					q.qry_value=strDate
					step.dfDateValue.selectedDate=null
					break;
				case "Edm.Double":
					q.qry_value=step.txtDoubleValue.text
					step.txtDoubleValue.text=""
					break;
				case "Edm.Int32":
					q.qry_value=step.txtIntegerValue.text
					step.txtIntegerValue.text=""
					break;
				case "Edm.Int16":
					q.qry_value=step.txtIntegerValue.text
					step.txtIntegerValue.text=""
					break;
				case "Edm.String":
					q.qry_value=step.txtStringValue.text
					step.txtStringValue.text=""
				break;
				case "Edm.Boolean":
					q.qry_value=step.cbBooleanValue.selected.toString()
					step.cbBooleanValue.selected=false
				break;
			}
			
			q.qry_required_field='WHAT'
			
			step.queries.addItem(q);	
			
			step.lstField.selectedIndex=-1
			step.lstOperator.selectedIndex=-1
		}
		
		private function HandleDateIntervalChange(event:Event):void
		{
			var o:Object=step.ddlDateInterval.selectedItem as Object
			step.minDate=DateUtils.dateAdd(o.interval,Number(o.number),step.maxDate)
			step.isValid=false;
		}
		
		private  function HandleTestQueryClick(event:Event):void
		{
			step.strResultTest.text="";
			step.strResultTest.visible=false;
			step.pgTest.visible=true;
			dataModel.ENTITY_QUERY=step.queries
			sendNotification(NotificationConstants.LOAD_STATIONS_NOTIFICATION,dataModel,'count')
		}
		
		private  function HandleMinDateChange(event:PropertyChangeEvent):void
		{
			var strDate:String=DateUtils.CastDateToString(step.minDate,"YYYY-MM-DD") + "T00:00:00";
			majQueries(step.lstFieldDATE,'ge',strDate,'MIN_DATE')
		}
		
		private  function HandleMaxDateChange(event:PropertyChangeEvent):void
		{
			var strDate:String=DateUtils.CastDateToString(step.maxDate,"YYYY-MM-DD") + "T00:00:00";
			majQueries(step.lstFieldDATE,'le',strDate,'MAX_DATE')
		}
		
		private  function HandleMinLatChange(event:PropertyChangeEvent):void
		{
			majQueries(step.lstFieldLAT,'ge',step.minLat,'MIN_LAT')
		}
		
		private  function HandleMaxLatChange(event:PropertyChangeEvent):void
		{
			majQueries(step.lstFieldLAT,'le',step.maxLat,'MAX_LAT')
		}
		
		private  function HandleMinLonChange(event:PropertyChangeEvent):void
		{
			majQueries(step.lstFieldLON,'ge',step.minLon,'MIN_LON')
		}
		
		private  function HandleMaxLonChange(event:PropertyChangeEvent):void
		{
			majQueries(step.lstFieldLON,'le',step.maxLon,'MAX_LON')
		}
		
		private function HandleQueriesChange(event:CollectionEvent):void
		{
			step.strResultTest.text=''
			step.strResultTest.visible=false
			step.pgTest.visible=false
			step.isValid=false;
		}
		
		//FUNCTION
		private function majQueries(ddList:DropDownList,operator:String,value:String,type:String):void
		{
			var xml:XML=ddList.selectedItem
			if (xml!=null){
				var q:QueryOdataVO=new QueryOdataVO()
				var idx:int
				q.qry_field=xml.attribute('Name')
				q.qry_type=xml.attribute('Type')
				q.qry_operator=operator
				q.qry_value=value
				q.qry_required_field=type	
				idx=getQueryIndex(type)
				if (idx==-1){
					step.queries.addItem(q);	
				}else{
					step.queries.setItemAt(q,idx)
				}
			}
		}
		
		private function getQueryIndex(type:String):int
		{
			var result:int=-1
			
			var query:QueryOdataVO	
			for each(query in step.queries){
				if (query.qry_required_field==type){
					result=step.queries.getItemIndex(query)
				}
			}
			
			return result
		}

		
		private function testStepIsValid():void
		{
			if(getQueryIndex('MIN_DATE')!=-1 &&	getQueryIndex('MAX_DATE')!=-1){
				if(getQueryIndex('MIN_LON')!=-1 && getQueryIndex('MAX_LON')!=-1){
					if(getQueryIndex('MIN_LAT')!=-1 && getQueryIndex('MAX_LAT')!=-1){
						step.isValid=true
					}
				}
			}	
		}
		
		//GETTER		
		public function get step():Step3
		{
			return viewComponent as Step3;
		}
	}
}