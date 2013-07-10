package org.ns.dataconnecteur.shell.view
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.PopUpManager;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.OLAP;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class OLAPMediator extends FlexMediator
	{
		public static const NAME:String = 'OLAPMediator';
		
		public function OLAPMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		public function respondToStationJoinQuerySelected(note:Notification):void
		{
			if ((note.getBody() as ArrayCollection).length==0){
				olap.columnChart.series=null;
				olap.colCatAxis.dataProvider=null;
				olap.legGroup.visible=false;
			} else {
				olap.myMXMLCube.dataProvider= note.getBody() as ArrayCollection
				olap.myMXMLCube.refresh();
			}
		}
		
		//REACTIONS

		
		//GETTER		
		public function get olap():OLAP
		{
			return this.viewComponent as OLAP;
		}
		
	}
}