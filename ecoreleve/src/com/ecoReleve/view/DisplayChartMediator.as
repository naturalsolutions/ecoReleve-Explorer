package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.StationEnhanceProxy;
	import com.ecoReleve.view.mycomponents.Display.chart.DisplayChart;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class DisplayChartMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "TimeLineMediator";		
		private var _dataProxy:StationEnhanceProxy;
 					
 		//constructeur
        public function DisplayChartMediator(viewComponent:DisplayChart)
        {
            super(NAME, viewComponent); 
        }
        
		override public function onRegister():void
		{
			super.onRegister();
			
			timeline.addEventListener(DisplayChart.PERIOD_DD,onChangePeriod)
			timeline.addEventListener(DisplayChart.PERIOD_hh,onChangePeriod)
			timeline.addEventListener(DisplayChart.PERIOD_mm,onChangePeriod)
			timeline.addEventListener(DisplayChart.PERIOD_MM,onChangePeriod)
			timeline.addEventListener(DisplayChart.PERIOD_YYYY,onChangePeriod)
				
			//récupération du proxy 
			_dataProxy=retrieveProxy(StationEnhanceProxy.NAME) as StationEnhanceProxy
		}
		
		// Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.STATIONS_ADDED_NOTIFICATION,
				NotificationConstants.STATIONS_FILTERED_NOTIFICATION,
				NotificationConstants.DECONNEXION_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{	
				case NotificationConstants.STATIONS_ADDED_NOTIFICATION: 
					timeline.stations=new ArrayCollection
					timeline.stations=aggregArraycollection(_dataProxy.stations as ArrayCollection,'YYYY','sta_date','sta_nbIndividual');
					 break;
			}
		} 	

		private function onChangePeriod(event:Event):void
		{		
			var period:String=event.type
			var labelDate:String
			timeline.stations=new ArrayCollection
			timeline.dateAxis.minPeriod=period	
			if (period=="YYYY"){
				labelDate='YYYY'		
			}else if (period=="MM"){
				labelDate='YYYY-MMM'
			}else if (period=="DD"){
				labelDate='YYYY-MMM-DD'
			}else if (period=="hh"){
				labelDate='YYYY-MMM-DD HH'
			}else if (period=="mm"){
				labelDate='YYYY-MMM-DD HH:NN'
			}
			timeline.chartCursor.categoryBalloonDateFormat=labelDate
			timeline.stations=aggregArraycollection(_dataProxy.stations as ArrayCollection,period,'sta_date','sta_nbIndividual');
		}
		
		private function aggregArraycollection(myArr:ArrayCollection,groupingType:String,dateField:String,sumField:String):ArrayCollection
		{
			var returnArrCol:ArrayCollection=new ArrayCollection;
			//var sums:Object=new Object;
			var sums:Dictionary=new Dictionary;
			var key:String;
			for each(var item:Object in myArr){
				if (groupingType=="YYYY"){
					key=String((item[dateField] as Date).getFullYear())		
				}else if (groupingType=="MM"){
					key=String((item[dateField] as Date).getFullYear() + "-" + (item[dateField] as Date).getMonth())
				}else if (groupingType=="DD"){
					key=String((item[dateField] as Date).getFullYear() + "-" + (item[dateField] as Date).getMonth()+ "-" + (item[dateField] as Date).getDate())
				}else if (groupingType=="hh"){
					key=String((item[dateField] as Date).getFullYear() + "-" + (item[dateField] as Date).getMonth()+ "-" + (item[dateField] as Date).getDate() + "-" + (item[dateField] as Date).getHours())
				}else if (groupingType=="mm"){
					key=String((item[dateField] as Date).getFullYear() + "-" + (item[dateField] as Date).getMonth()+ "-" + (item[dateField] as Date).getDate() + "-" + (item[dateField] as Date).getHours()+ "-" + (item[dateField] as Date).getMinutes())
				}
				sums[key]=((sums[key] == null)? 0 : sums[key]) + item[sumField];  //SUM
				//sums[key]=((sums[key] == null)? 0 : sums[key]) + 1;  //COUNT
			}
			
			for (var i:Object in sums)
			{	
				var d:Date;	
				var arr:Array=new Array						
				if (groupingType=="YYYY"){
					d=new Date(i.toString(),null);
				}else if (groupingType=="MM"){
					arr=String(i).split("-");
					d= new Date(arr[0],arr[1]);
				}else if (groupingType=="DD"){
					arr=String(i).split("-");
					d= new Date(arr[0],arr[1],arr[2]);
				}else if (groupingType=="hh"){
					arr=String(i).split("-");
					d= new Date(arr[0],arr[1],arr[2],arr[3]);
				}else if (groupingType=="mm"){
					arr=String(i).split("-");
					d= new Date(arr[0],arr[1],arr[2],arr[3],arr[4]);
				}	
				returnArrCol.addItem({DATE:d,VALUE:sums[i]})
			}
			
			return returnArrCol
		}
		
		//marche avec timeline component in genericomponent
		/*private function filterHandler(event:Timeline.event.FilterEvent):void
		{
			
			_dataProxy.filterStations(event.data as DataFilterParameters,"time");
		}*/
		
        protected function get timeline():DisplayChart
        {
            return viewComponent as DisplayChart;
        }
    }
}