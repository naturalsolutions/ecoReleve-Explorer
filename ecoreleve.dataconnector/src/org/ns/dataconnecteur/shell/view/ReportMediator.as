package org.ns.dataconnecteur.shell.view
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.Report;
	import org.ns.dataconnecteur.shell.view.components.enhancer.AttributeEnhance;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	public class ReportMediator extends FlexMediator
	{
		public static const NAME:String = 'ReportMediator';
		
		public function ReportMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new PieChartMediator(report.myPie));
			registerMediator(new DataGridMediator(report.myDg));
			registerMediator(new OLAPMediator(report.myOlap));
			registerMediator(new TimeLineMediator(report.myTimeLine));
		}
		
		//RESPONDER
		
		public function respondToStationCounted(note:INotification):void
		{
			report.txtTotalStations.text=String(note.getBody() as Number)
			sendNotification(NotificationConstants.LOG_NOTIFICATION,"stations counted","log")
		}
		
		public function respondToStationsAdded(note:INotification):void
		{
			report.txtAddedStations.text="+" + String(note.getBody() as Number)
			report.fadeAndHide.end()
			report.fadeAndHide.play()
			sendNotification(NotificationConstants.LOG_NOTIFICATION,"stations added","log")
		}
		
		public function respondToQueryCounted(note:INotification):void
		{
			//report.txtTotalQueries.text=String(note.getBody() as Number)
			sendNotification(NotificationConstants.LOG_NOTIFICATION,"queries counted","log")
		}
		
		public function respondToQueryUsed(note:INotification):void
		{
			//report.qryUsed.dataProvider=note.getBody() as ArrayCollection
			sendNotification(NotificationConstants.LOG_NOTIFICATION,"stations used","log")
		}
		
		//REACTIONS
		
		//GETTER		
		public function get report():Report
		{
			return this.viewComponent as Report;
		}
		
	}
}