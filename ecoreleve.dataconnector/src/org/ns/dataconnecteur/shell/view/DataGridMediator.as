package org.ns.dataconnecteur.shell.view
{
	import flash.events.MouseEvent;
	import mx.collections.ArrayCollection;
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.DataGrid;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class DataGridMediator extends FlexMediator
	{
		public static const NAME:String = 'DataGridMediator';
		
		public function DataGridMediator(viewComponent:Object)
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
				datagrid.stations=null;
			} else {
				datagrid.stations= note.getBody() as ArrayCollection;
			}
		}
		
		//REACTIONS

		
		//GETTER		
		public function get datagrid():DataGrid
		{
			return this.viewComponent as DataGrid;
		}
		
	}
}