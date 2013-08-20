package org.ns.RemoteImportModule.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import org.ns.common.utils.DateUtils;
	
	import org.ns.RemoteImportModule.controller.*;
	import org.ns.RemoteImportModule.view.components.QueryCreator;
	import org.ns.common.model.VO.QueryVO;
	import org.ns.genericComponents.geonames.VO.ToponymVO;
	import org.ns.genericComponents.geonames.event.ToponymEvent;
	import org.openscales.geometry.LineString;
	import org.openscales.geometry.Point;
	import org.openscales.geometry.basetypes.Bounds;
	import org.openscales.proj4as.ProjProjection;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class QueryCreatorMediator extends FlexMediator
	{
		public static const NAME:String = 'QueryCreatorMediator';
		
		private var minLat:Number=-90
		private var maxLat:Number=90
		private var minLon:Number=-180
		private var maxLon:Number=180
		
		public function QueryCreatorMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			querycreator.addEventListener("CLOSE",HandleCloseClick)
			querycreator.addEventListener("RECORDQUERY",HandleRecordQueryClick)
			querycreator.addEventListener("USEQUERY",HandleUseQueryClick)
			querycreator.addEventListener("CANCEL",HandleCancelClick)
			querycreator.addEventListener("TESTQUERY",HandleTestQueryClick)
			querycreator.addEventListener("CHANGE_EXTENT",HandleSliderChange)
			querycreator.addEventListener("CHANGE_INTERVAL",HandleDateIntervalChange)
			querycreator.geoSearch.addEventListener(ToponymEvent.COMPLETE,geonameResultHandler);
			
			//min date by defaut is last two days 
			querycreator.mindate.selectedDate=DateUtils.dateAdd('date',-2,querycreator.maxdate.selectedDate)
		}
		
		//RESPONDER
		public function respondToStationsCounted (note:Notification):void
		{			
			querycreator.strResultTest.text=String(note.getBody()) + ' station(s)'
			querycreator.strResultTest.visible=true
			querycreator.pgTest.visible=false	
		}
		
		public function respondToRefresh(note:INotification):void
		{
			PopUpManager.removePopUp(querycreator);
			removeMediator(QueryCreatorMediator.NAME);
		}
		
		//REACTIONS
		
		private function HandleDateIntervalChange(event:Event):void
		{
			var item:String=querycreator.ddlDateInterval.selectedItem
			switch (item)
			{
				case 'last 2 days':				
					querycreator.mindate.selectedDate=DateUtils.dateAdd('date',-2,querycreator.maxdate.selectedDate)
					break;
				case 'last month':
					querycreator.mindate.selectedDate=DateUtils.dateAdd('month',-1,querycreator.maxdate.selectedDate)
					break;
				case 'last year':
					querycreator.mindate.selectedDate=DateUtils.dateAdd('month',-12,querycreator.maxdate.selectedDate)
					break;
				case 'last 10 years':
					querycreator.mindate.selectedDate=DateUtils.dateAdd('month',-120,querycreator.maxdate.selectedDate)
					break;
			}
		}
		
		private function geonameResultHandler(event:ToponymEvent):void
		{
			var toponym:ToponymVO=event.data as ToponymVO

			minLat=toponym.lat - 0.20 
			maxLat=toponym.lat + 0.20
			minLon=toponym.lng - 0.20
			maxLon=toponym.lng + 0.20
				
			querycreator.slider.value=0;
			querycreator.slider.enabled=true;
			
			majLatLonDisplay()	
		}
		
		private function HandleSliderChange(event:Event):void
		{
			majLatLonDisplay()
		}
		
		private function majLatLonDisplay():void
		{

			querycreator.minLat.text=String(Math.max(-90,Math.min(minLat,minLat - querycreator.slider.value)))
			querycreator.maxLat.text=String(Math.min(90,Math.max(maxLat,maxLat + querycreator.slider.value)))
			querycreator.minLon.text=String(Math.max(-180,Math.min(minLon,minLon - querycreator.slider.value)))
			querycreator.maxLon.text=String(Math.min(180,Math.max(maxLon,maxLon + querycreator.slider.value)))

			
			var pt1:Point=new Point(Number(querycreator.minLon.text), Number(querycreator.minLat.text));
			pt1.transform(ProjProjection.getProjProjection('EPSG:4326'),ProjProjection.getProjProjection('EPSG:900913'))			
			var pt2:Point=new Point(Number(querycreator.maxLon.text), Number(querycreator.minLat.text));
			pt2.transform(ProjProjection.getProjProjection('EPSG:4326'),ProjProjection.getProjProjection('EPSG:900913'))
			var dist1:Number=Math.round(pt1.distanceTo(pt2)/1000)
			
			pt1=new Point(Number(querycreator.minLon.text), Number(querycreator.minLat.text));
			pt1.transform(ProjProjection.getProjProjection('EPSG:4326'),ProjProjection.getProjProjection('EPSG:900913'))			
			pt2=new Point(Number(querycreator.minLon.text), Number(querycreator.maxLat.text));
			pt2.transform(ProjProjection.getProjProjection('EPSG:4326'),ProjProjection.getProjProjection('EPSG:900913'))
			var dist2:Number=Math.round(pt1.distanceTo(pt2)/1000)
				
			querycreator.txtArea.text=String(dist1) + " km x " + String(dist2) + " km"
		}
		
		private function HandleCloseClick(event:Event):void
		{
			PopUpManager.removePopUp(querycreator);
			removeMediator(QueryCreatorMediator.NAME);
		}
		
		private function HandleTestQueryClick(event:Event):void
		{
			querycreator.strResultTest.text="";
			querycreator.strResultTest.visible=false;
			querycreator.pgTest.visible=true;
			querycreator.btnRecord.enabled=false
			querycreator.btnUse.enabled=false	
			sendNotification(NotificationConstants.TEST_QUERY_NOTIFICATION,createQuery() as QueryVO,'test query');
		}
		
		private function HandleRecordQueryClick(event:Event):void
		{
			var query:QueryVO=createQuery() as QueryVO
			query.qry_persist=true
			sendNotification(NotificationConstants.RECORD_QUERY_NOTIFICATION,query,'record query');
		}
		
		private function HandleUseQueryClick(event:Event):void
		{
			var query:QueryVO=createQuery() as QueryVO
			query.qry_persist=false
			sendNotification(NotificationConstants.RECORD_QUERY_NOTIFICATION,query,'record query');
		}
		
		private function HandleCancelClick(event:Event):void
		{
			PopUpManager.removePopUp(querycreator);
			removeMediator(QueryCreatorMediator.NAME);
		}
		private function createQuery():QueryVO
		{
			var query:QueryVO=new QueryVO;
			
			query.qry_minDate=querycreator.mindate.selectedDate
			query.qry_maxDate=querycreator.maxdate.selectedDate
			query.qry_minLat=Number(querycreator.minLat.text)
			query.qry_maxLat=Number(querycreator.maxLat.text)
			query.qry_minLon=Number(querycreator.minLon.text)
			query.qry_maxLon=Number(querycreator.maxLon.text)
			query.qry_idTaxon=NaN
			query.qry_topicFr=querycreator.species.text
			query.qry_isTaxonFather=false
			query.qry_dataOwner="my"
			query.qry_format="flat"
			query.qry_maxResult=2500
			query.qry_name=querycreator.queryName.text
			
			return query
		}
		
		//GETTER		
		public function get querycreator():QueryCreator
		{
			return this.viewComponent as QueryCreator;
		}
		
	}
}