package Timeline
{
	import Timeline.controls.CustomDateFilter;
	import Timeline.controls.FormattedDateTimeAxis;
	import Timeline.controls.RangeSelector;
	import Timeline.event.FilterEvent;
	import Timeline.event.TimeIntervalEvent;
	import Timeline.event.TimeScaleEvent;
	import Timeline.renderer.ScrollableAxisRenderer;
	
	import ToolTip.HtmlToolTip;
	
	import com.fnicollet.datafilter.filter.DataFilterParameters;
	
	import flash.utils.Dictionary;
	
	import mx.charts.AxisRenderer;
	import mx.charts.ChartItem;
	import mx.charts.ColumnChart;
	import mx.charts.LogAxis;
	import mx.charts.chartClasses.Series;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.series.ColumnSeries;
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.ToolTipEvent;
	
	public class Timeline extends VBox
	{
		
		[Inspectable(category="General", type="ArrayCollection", defaultValue="null")]
		private var _TimeLineSource:ArrayCollection=new ArrayCollection;
		private var TimeLineSourceChanged : Boolean = false;
		
		private var _dateFieldName:String;
		private var _aggregFieldName:String;
		private var myChart:ColumnChart;
		private var mydatetimeaxis:FormattedDateTimeAxis
		private var logAxis:LogAxis;
		private var strInterval:String="years";
		private var selectedDate:ArrayCollection=new ArrayCollection();
		
		[Bindable]
		public function get TimeLineSource():ArrayCollection
		{
			return _TimeLineSource;
		}
		
		public function set TimeLineSource(arrCol:ArrayCollection) : void 
		{
			_TimeLineSource=arrCol
			TimeLineSourceChanged=true;
			this.invalidateProperties();
		}
		
		public function set dateFieldName(value:String) : void 
		{
			_dateFieldName=value
		}
		
		public function set aggregFieldName(value:String) : void 
		{
			_aggregFieldName=value
		}
		
		override protected function commitProperties():void
		{
		 	super.commitProperties();
		 	//modifie la source de la TimeLine dès que la source change
		 	if(TimeLineSourceChanged == true && _TimeLineSource!=null){
				if (_TimeLineSource.length==0){
					resetChart();
					TimeLineSourceChanged = false;
				}else{
			 		var arr:Array=getMinMaxDate(_TimeLineSource,_dateFieldName);				
					var d1:Date=arr[0]
					var d2:Date=arr[1]
					//calcul le nb de jour
	        		var nbDay:Number=Math.round(d2.getTime()-d1.getTime()) / (1000 * 60 * 60 * 24);
					var str:String=CalculInterval(nbDay)
					
					if (str=="years"){
						mydatetimeaxis.minimum=dateAdd("fullyear",-2,d1)
						mydatetimeaxis.maximum=dateAdd("fullyear",2,d2)	
					}else if (str=="months"){
						mydatetimeaxis.minimum=dateAdd("month",-2,d1)
						mydatetimeaxis.maximum=dateAdd("month",2,d2)
					}else if (str=="days"){
						mydatetimeaxis.minimum=dateAdd("date",-3,d1)
						mydatetimeaxis.maximum=dateAdd("date",3,d2)
					}else if (str=="hours"){
						mydatetimeaxis.minimum=dateAdd("hours",-6,d1)
						mydatetimeaxis.maximum=dateAdd("hours",6,d2)
					}
		  			strInterval=str;
		  			
		            MajDataSource()
			  		TimeLineSourceChanged = false;
				}
		  	}		  	
		}
		
		
		public function Timeline()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			myChart=new ColumnChart;
			myChart.percentWidth=100;
			myChart.percentHeight=100;
			myChart.addEventListener(TimeScaleEvent.SCALE_CHANGE,ScaleChangeHandler)
			myChart.showDataTips=true;
			//tooltip
			var tip1:String;
			tip1 = "<font color='#076baa' size='+4'><b>Mouse use</b></font><br><br>";
			tip1 += "<img src='assets/mouseleftmove.png' width='20' height='20' hspace='3' vspace='3' alt='test'/>";            
			tip1 += "<b>To create a selection using the timeline</b><br>";
			tip1 += "<b>hold left button down</b>";
			myChart.toolTip=tip1;
			myChart.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreateToolTip)
			
			//create range selector
			var rangeSelector:RangeSelector=new RangeSelector()	
			myChart.annotationElements.push(rangeSelector)			
			rangeSelector.addEventListener(TimeIntervalEvent.INTERVAL_CHANGE,IntervalChangeHandler)
				
			//create datetime axis
			mydatetimeaxis=new FormattedDateTimeAxis;
			mydatetimeaxis.minimum=new Date(1990,00,01)
			mydatetimeaxis.maximum=new Date(2011,00,01)
			mydatetimeaxis.alignLabelsToUnits=true;
			mydatetimeaxis.displayLocalTime=false;
			mydatetimeaxis.parseFunction=createDate;
			//asign to horizontal axis of chart
			myChart.horizontalAxis=mydatetimeaxis;			
			//create horizontal renderer axis
			var myHAxisRenderer:ScrollableAxisRenderer=new ScrollableAxisRenderer;
			myHAxisRenderer.axis=myChart.horizontalAxis;
			//tooltip
			var tip2:String;
			tip2 = "<font color='#076baa' size='+4'><b>Mouse use</b></font><br><br>";
			tip2 += "<img src='assets/mouseleftmove.png' width='32' height='32' hspace='3' vspace='3'/>"; 
			tip2 += "<b>Move mouse with pressed left button</b><br>";
			tip2 += "<b>for exploring</b><br>";
			tip2 += "<img src='../assets/mousescroll.png' width='20' height='20' hspace='3' vspace='3'/>";            
			tip2 += "<b>Scroll with mouse-wheel for drilling</b>";
			myHAxisRenderer.toolTip=tip2
			myHAxisRenderer.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,onCreateToolTip)
				
			//asign to horizontal renderer axis of chart
			myChart.horizontalAxisRenderers=[myHAxisRenderer];
			
			//create log axis
			logAxis=new LogAxis;

			//assign to vertical axis
			myChart.verticalAxis=logAxis;
			//create vertical renderer axis of chart
			var myVAxisRenderer:AxisRenderer=new AxisRenderer;
			myVAxisRenderer.axis=myChart.verticalAxis;
			myVAxisRenderer.visible=true;
			//assign to vertical renderer axis of chart
			myChart.verticalAxisRenderers=[myVAxisRenderer];
				
			this.addChild(myChart)
		}	

		private function resetChart():void 
		{
			myChart.series=[]
			myChart.dataProvider=null
		}

		private function onCreateToolTip(event:ToolTipEvent):void 
		{
			var tip:HtmlToolTip = new HtmlToolTip();
			var component:UIComponent=event.currentTarget as UIComponent
			tip.text=component.toolTip
			event.toolTip = tip;      	   
		}
		
		private function MajDataSource():void 
		{	
			if (_TimeLineSource!=null){
				mydatetimeaxis.alignLabelsToUnits=true;
				mydatetimeaxis.dataUnits=strInterval;
				
				myChart.dataProvider= aggregArraycollection(_TimeLineSource,strInterval,_dateFieldName,_aggregFieldName); //_TimeLineSource	
				
				//reassign min and max value to the verticalaxis
				var max:Number=0;
				var item:Object;
				for each(item in myChart.dataProvider){
					if (item["VALUE"]>max){
						max=item["VALUE"]
					}
				}
				
				logAxis.minimum=0;
				logAxis.maximum=max;
				
				var colSerie:ColumnSeries=new ColumnSeries;
				colSerie.xField="DATE"; 
				colSerie.yField="VALUE"; 
				colSerie.labelFunction=columnSeries_labelFunc;
				colSerie.setStyle("labelPosition","outside");
				myChart.series=[colSerie];
							
			}
		}
		
		private function columnSeries_labelFunc(chartItem:ChartItem, series:Series):String 
		{
			var col:String = ColumnSeries(chartItem.element).yField;
			return String(chartItem.item[col]);
		}
		
		protected function IntervalChangeHandler(event:TimeIntervalEvent):void 
		{
			var _filtParam:DataFilterParameters=new DataFilterParameters;
			
			if (event.data==null){			//unselect interval ==> filtre null			
				_filtParam.filterClass=CustomDateFilter;
				_filtParam.filterKeys=[_dateFieldName];
				_filtParam.filterValues=["All"];
				this.dispatchEvent(new FilterEvent("FilterParameters",true,true,_filtParam))
			}else {							//select interval			
				_filtParam.filterClass=CustomDateFilter;
				_filtParam.filterKeys=[_dateFieldName];
				_filtParam.filterValues=[event.data[0],event.data[1]];
				_filtParam.active=true;
				_filtParam.invert=false;
				this.dispatchEvent(new FilterEvent("FilterParameters",true,true,_filtParam))
			}
		}
		
		protected function ScaleChangeHandler(event:TimeScaleEvent):void 
		{
			var str:String=CalculInterval(Number(event.data))
			//si l'interval a changé alors on fait une MAJ
			if (str!=strInterval){
				strInterval=str
				MajDataSource()
			}
		}

		 protected function aggregArraycollection(myArr:ArrayCollection,groupingType:String,dateField:String,sumField:String):ArrayCollection
		 {
		 	var returnArrCol:ArrayCollection=new ArrayCollection;
		 	//var sums:Object=new Object;
		 	var sums:Dictionary=new Dictionary;
		 	var key:String;
			for each(var item:Object in myArr){
				if (groupingType=="years"){
					key=String((item[dateField] as Date).getFullYear())		
				}else if (groupingType=="months"){
					key=String((item[dateField] as Date).getFullYear() + "-" + (item[dateField] as Date).getMonth())
				}else if (groupingType=="days"){
					key=String((item[dateField] as Date).getFullYear() + "-" + (item[dateField] as Date).getMonth()+ "-" + (item[dateField] as Date).getDate())
				}else if (groupingType=="hours"){
					key=String((item[dateField] as Date).getFullYear() + "-" + (item[dateField] as Date).getMonth()+ "-" + (item[dateField] as Date).getDate() + "-" + (item[dateField] as Date).getHours())
				}
				sums[key]=((sums[key] == null)? 0 : sums[key]) + item[sumField];  //SUM
				//sums[key]=((sums[key] == null)? 0 : sums[key]) + 1;  //COUNT
			}
			
			for (var i:Object in sums)
			{	
				var d:Date;	
				var arr:Array=new Array						
				if (groupingType=="years"){
					d=new Date(i.toString(),null);
				}else if (groupingType=="months"){
					arr=String(i).split("-");
					d= new Date(arr[0],arr[1]);
				}else if (groupingType=="days"){
					arr=String(i).split("-");
					d= new Date(arr[0],arr[1],arr[2]);
				}else if (groupingType=="hours"){
					arr=String(i).split("-");
					d= new Date(arr[0],arr[1],arr[2],arr[3]);
				}	
			    returnArrCol.addItem({DATE:d,VALUE:sums[i]})
			}
			
			return returnArrCol
		 }
		 
		//SANS CETTE FONCTION CELA NE MARCHE PAS!!! 
        protected function createDate(s:Date):Date 
        {
            return s;
        }
        
        
        protected function CalculInterval(nbDay:Number):String
        {
			if (nbDay<6){
        		return "hours"
            }else if (nbDay >=6 && nbDay<300){
        		return "days"
            }else if (nbDay>=300 && nbDay<=2000){
				return "months"				
			}else if (nbDay>2000){
				return "years"				
			}
			return "years"
        }
        
        protected function getMinMaxDate(arr:ArrayCollection,fieldDate:String):Array
        {
        	var _MinDate:Date;
		    var _MaxDate:Date;
			var i:uint;
			var length:Number=arr.length;
			var item:Object
			var firstItem:Object=arr.getItemAt(0) as Object
						
			_MinDate=firstItem[fieldDate]
			_MaxDate=firstItem[fieldDate]
			
			for (i;i<length;i++){
				item=arr.getItemAt(i) as Object
				if (item[fieldDate] < _MinDate){
					_MinDate=item[fieldDate]
				}else if (item[fieldDate] > _MaxDate){
					_MaxDate=item[fieldDate]
				}
			}
			
			return [_MinDate,_MaxDate]
        }
        
        protected function dateAdd(datepart:String = "", number:Number = 0, date:Date = null):Date 
        {
            if (date == null) {
                //retourne la date courante
                date = new Date();
            }
 
            var returnDate:Date = new Date(date.time);
 
            switch (datepart.toLowerCase()) {
                case "fullyear":
                case "month":
                case "date":
                case "hours":
                case "milliseconds":
                    returnDate[datepart] += number;
                    break;
                default:
                    //ne fait rien
                    break;
            }
            return returnDate;
        }

        
        protected function getQarter(d:Date):String 
        {
            switch (d.getMonth())
            {
            	case 0,1,2:
            		return "Q1"
            	break;
            	case 3,4,5:
            		return "Q2"
            	break;
            	case 6,7,8:
            		return "Q3"
            	break;
            	case 9,10,11:
            		return "Q4"
            	break;	
            }
            return ""
        }
		
	}
}