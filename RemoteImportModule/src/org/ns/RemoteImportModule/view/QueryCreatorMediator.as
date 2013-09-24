package org.ns.RemoteImportModule.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.ns.RemoteImportModule.controller.*;
	import org.ns.RemoteImportModule.model.proxy.ConnectorProxy;
	import org.ns.RemoteImportModule.view.components.QueryCreator;
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.utils.DateUtils;
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
			querycreator.addEventListener("CHANGE_CREATOR_TYPE",HandlecreatorChange)	
			querycreator.geoSearch.addEventListener(ToponymEvent.COMPLETE,geonameResultHandler);
			
			//min date by defaut is last two days 
			querycreator.mindate.selectedDate=DateUtils.dateAdd('date',-2,querycreator.maxdate.selectedDate)
			var pxyConnector:ConnectorProxy=retrieveProxy(ConnectorProxy.NAME) as ConnectorProxy;
			var connector:RemoteConnectorVO=pxyConnector.getConnector;
			var url_service:String=connector.rd_url;
			var url_service_array:Array=url_service.split("/");
			var url:String="";
			for(var i=0;i<url_service_array.length-1;i++)
					url+=url_service_array[i]+"/";
			trace("url service: "+url)
			//creation of the service that will return a list of views
			var views_service:HTTPService = new HTTPService(); 
			views_service.url = url+"map_views_list"; 
			views_service.method = "POST"; 
			views_service.resultFormat = 'e4x';
			views_service.addEventListener("result", views_httpResult); 
			views_service.addEventListener("fault", views_httpFault); 
			//service.send(parameters); 
			views_service.send(); 
			
			//creation of the service that will return a list of fieldacivities
			var fa_service:HTTPService = new HTTPService(); 
			fa_service.url = url+"fa_list"; 
			fa_service.method = "POST"; 
			fa_service.resultFormat = 'e4x';
			fa_service.addEventListener("result", fa_httpResult); 
			fa_service.addEventListener("fault", fa_httpFault); 
			//service.send(parameters); 
			fa_service.send();
			
			//creation of the service that will return a list of regions
			var region_service:HTTPService = new HTTPService(); 
			region_service.url = url+"region_list"; 
			region_service.method = "POST"; 
			region_service.resultFormat = 'e4x';
			region_service.addEventListener("result", region_httpResult); 
			region_service.addEventListener("fault", region_httpFault); 
			//service.send(parameters); 
			region_service.send();
			
			//creation of the service that will return a list of places
			var place_service:HTTPService = new HTTPService(); 
			place_service.url = url+"place_list"; 
			place_service.method = "POST"; 
			place_service.resultFormat = 'e4x';
			place_service.addEventListener("result", place_httpResult); 
			place_service.addEventListener("fault", place_httpFault); 
			//service.send(parameters); 
			place_service.send();
		}
		
		
		
		//Result for views
		public function views_httpResult(event:ResultEvent):void { 
			var result:XML = event.result as XML; 
			var view:XML;			
			//trace("result: "+result.children())
			for each (view in result.children()){
				//trace("viewresult: "+view.text())
				//trace("viewresult: "+view.@id)
				querycreator.views_array_list_.addItem({label:view.text().toString(),id:view.@id});
			}
			querycreator.views_list_.selectedIndex=0;
			//trace("viewselected: "+querycreator.views_list_.selectedItem.id);			
		} 
		
		public function views_httpFault(event:FaultEvent):void { 
			var faultstring:String = event.fault.faultString; 
			trace("view_error: "+faultstring); 
		} 
		
		//result for fieldactivities
		public function fa_httpResult(event:ResultEvent):void { 
			var result:XML = event.result as XML; 
			var fa:XML;			
			//trace("faresult: "+result.children())
			for each (fa in result.children()){
				//trace("faresult: "+fa.text())
				//trace("viewresult: "+view.@id)
				querycreator.fa_array_list_.addItem({label:fa.text().toString()});
			}
			querycreator.fa_list_.selectedIndex=3;
			//trace("faselected: "+querycreator.fa_list_.selectedItem.label);
			//(querycreator.list_.dataProvider as ArrayCollection).refresh()
			//trace(querycreator.list_.getChildAt(0).)
			//querycreator.array_list_.;
			//Do something with the result. 
		} 
		
		public function fa_httpFault(event:FaultEvent):void { 
			var faultstring:String = event.fault.faultString; 
			trace("fa_error: "+faultstring); 
		} 
		
		//result for region
		public function region_httpResult(event:ResultEvent):void { 
			var result:XML = event.result as XML; 
			var region:XML;			
			//trace("faresult: "+result.children())
			for each (region in result.children()){
				//trace("faresult: "+fa.text())
				//trace("viewresult: "+view.@id)
				querycreator.region_array_list_.addItem({label:region.text().toString()});
			}
			querycreator.region_list_.selectedIndex=2;
			//trace("regionselected: "+querycreator.region_list_.selectedItem.label);
			//(querycreator.list_.dataProvider as ArrayCollection).refresh()
			//trace(querycreator.list_.getChildAt(0).)
			//querycreator.array_list_.;
			//Do something with the result. 
		} 
		
		public function region_httpFault(event:FaultEvent):void { 
			var faultstring:String = event.fault.faultString; 
			trace("region_error: "+faultstring); 
		} 
		
		//result for place
		public function place_httpResult(event:ResultEvent):void { 
			var result:XML = event.result as XML; 
			var place:XML;			
			//trace("placeresult: "+result.children())
			for each (place in result.children()){
				//trace("faresult: "+fa.text())
				//trace("viewresult: "+view.@id)
				querycreator.place_array_list_.addItem({label:place.text().toString()});
			}
			querycreator.place_list_.selectedIndex=2;
			//trace("placeselected: "+querycreator.place_list_.selectedItem.label);
			//(querycreator.list_.dataProvider as ArrayCollection).refresh()
			//trace(querycreator.list_.getChildAt(0).)
			//querycreator.array_list_.;
			//Do something with the result. 
		} 
		
		public function place_httpFault(event:FaultEvent):void { 
			var faultstring:String = event.fault.faultString; 
			trace("place_error: "+faultstring); 
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
					querycreator.group_min_max_date.setVisible(true);
					break;
				case 'last month':
					querycreator.mindate.selectedDate=DateUtils.dateAdd('month',-1,querycreator.maxdate.selectedDate)
					querycreator.group_min_max_date.setVisible(true);
					break;
				case 'last year':
					querycreator.mindate.selectedDate=DateUtils.dateAdd('month',-12,querycreator.maxdate.selectedDate)
					querycreator.group_min_max_date.setVisible(true);
					break;
				case 'last 10 years':
					querycreator.mindate.selectedDate=DateUtils.dateAdd('month',-120,querycreator.maxdate.selectedDate)
					querycreator.group_min_max_date.setVisible(true);
					break;
				case 'no date':
					querycreator.mindate.selectedDate=DateUtils.dateAdd('month',-(120*100),querycreator.maxdate.selectedDate)
					querycreator.group_min_max_date.setVisible(false);
					//querycreator.maxdate.selectedDate=null
					break;
			}
		}
		
		private function HandlecreatorChange(event:Event):void
		{
			var item:String=querycreator.choosetype.selectedItem
			switch (item)
			{
				case 'eReleve':	
					querycreator.groupfa.setVisible(true);
					querycreator.groupfa.height=20;
					querycreator.groupfa.width=200;
					querycreator.groupplace.setVisible(true);
					querycreator.groupplace.height=20;
					querycreator.groupplace.width=200;
					querycreator.groupregion.setVisible(true);
					querycreator.groupregion.height=20;
					querycreator.groupregion.width=200;
					querycreator.groupview.setVisible(true);
					querycreator.groupview.height=20;
					querycreator.groupview.width=200;
					querycreator.grouplatlon.setVisible(false);
					querycreator.grouplatlon.height=0;
					querycreator.grouplatlon.width=0;
					querycreator.groupspecies.setVisible(false);
					querycreator.groupspecies.height=0;
					querycreator.groupspecies.width=0;
					querycreator.geoSearch.setVisible(false);
					querycreator.geoSearch.height=0;
					querycreator.geoSearch.width=0;
					trace('eReleve mode')
					break;
				case 'Classic':
					querycreator.groupfa.setVisible(false);
					querycreator.groupfa.height=0;
					querycreator.groupfa.width=0;
					querycreator.groupplace.setVisible(false);
					querycreator.groupplace.height=0;
					querycreator.groupplace.width=0;
					querycreator.groupregion.setVisible(false);
					querycreator.groupregion.height=0;
					querycreator.groupregion.width=0;
					querycreator.groupview.setVisible(false);
					querycreator.groupview.height=0;
					querycreator.groupview.width=0;
					querycreator.grouplatlon.setVisible(true);
					querycreator.grouplatlon.height=20;
					querycreator.grouplatlon.width=200;
					querycreator.groupspecies.setVisible(true);
					querycreator.groupspecies.height=20;
					querycreator.groupspecies.width=200;
					querycreator.geoSearch.setVisible(true);
					querycreator.geoSearch.height=20;
					querycreator.geoSearch.width=200;
					trace('Classic mode')
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
			//query.qry_FieldActivity=querycreator.FieldActivity.text	
			query.qry_FieldActivity=querycreator.fa_list_.selectedItem.label		
			//query.qry_region=querycreator.Region.text
			query.qry_region=querycreator.region_list_.selectedItem.label	
			//query.qry_place=querycreator.Place.text
			query.qry_place=querycreator.place_list_.selectedItem.label	
			query.qry_ViewName=	querycreator.views_list_.selectedItem.id
			return query
		}
		
		//GETTER		
		public function get querycreator():QueryCreator
		{
			return this.viewComponent as QueryCreator;
		}
		
	}
}