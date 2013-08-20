package org.ns.dataconnecteur.shell.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.PieChart;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class PieChartMediator extends FlexMediator
	{
		public static const NAME:String = 'PieChartMediator';
		
		public function PieChartMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		public function respondToStationResumeDatasource(note:Notification):void
		{
			if ((note.getBody() as ArrayCollection).length==0){
				piechart.pieChart.dataProvider=null;
			} else {
				piechart.pieChart.dataProvider= note.getBody() as ArrayCollection;
			}
		}
		
		//REACTIONS

		
		//GETTER		
		public function get piechart():PieChart
		{
			return this.viewComponent as PieChart;
		}
		
	}
}