package org.ns.genericComponents.timeline
{
	import flash.events.Event;
	
	import mx.charts.BarChart;
	import mx.charts.DateTimeAxis;
	import mx.charts.series.ColumnSeries;
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import org.ns.genericComponents.timeline.skin.TimelineSkin;
	
	import spark.components.SkinnableContainer;
	import spark.components.VSlider;
	
	public class Timeline extends SkinnableContainer
	{
		[SkinPart(required="true")] public var chart:BarChart;
		[SkinPart(required="true")] public var slider:VSlider;
		
		private var _dataProvider:ArrayCollection=new ArrayCollection;
		private var dataProviderChanged : Boolean = false;
		
		private var _classFieldName:String
		private var _dateFieldName:String
		private var _valueFieldName:String
		
		//getter ans setter---------------------------------------------
		
		[Bindable]
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:ArrayCollection) : void 
		{
			_dataProvider=value
			dataProviderChanged=true;
			this.invalidateProperties();
		}
		
		public function set dateFieldName(value:String) : void 
		{
			_dateFieldName=value
		}
		
		public function set classFieldName(value:String) : void 
		{
			_classFieldName=value
		}
		
		public function set valueFieldName(value:String) : void 
		{
			_valueFieldName=value
		}
		
		//-----------------------------------------------------------------------
		
		public function Timeline()
		{
			super();
			setStyle("skinClass",TimelineSkin);
			addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		
		private function initComponent(pEvent:FlexEvent):void
		{
			slider.addEventListener(Event.CHANGE,changeTimeUnit)
		}
		
		//OVERRIDES----------------------------------------------------------------------------------------------------
		override protected function createChildren():void 
		{
			super.createChildren();
		}
			
		override protected function measure():void 
		{
			super.measure();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(dataProviderChanged == true && _dataProvider!=null){
				var colSerie:ColumnSeries=new ColumnSeries;
				colSerie.xField="date"; 
				colSerie.yField="Profit";
				chart.series=[colSerie]
				chart.dataProvider=_dataProvider
				dataProviderChanged = false;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		//PRIVATE----------------------------------------------------------------------------------------------------
		
		private function changeTimeUnit(event:Event):void
		{
			switch (slider.value){
				case 1:
					(chart.horizontalAxis as DateTimeAxis).dataUnits="year"
					break;
				case 2:
					(chart.horizontalAxis as DateTimeAxis).dataUnits="months"
					break;
				case 3:
					(chart.horizontalAxis as DateTimeAxis).dataUnits="days"
					break;
				case 4:
					(chart.horizontalAxis as DateTimeAxis).dataUnits="hours"
					break;	
			}	
		}
	}
}