package org.ns.dataconnecteur.shell.view
{	
	import flash.events.MouseEvent;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.ribbon.DeletePanel;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class DeletePanelMediator extends FlexMediator
	{
		public static const NAME:String = 'DeletePanelMediator';
		
		public function DeletePanelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		
		
		//REACTIONS
		public function reactToBtnDeleteAll$Click(event:MouseEvent):void
		{
			sendNotification(NotificationConstants.DELETE_ALL_STATIONS_NOTIFICATION);
		}
	
		//GETTER		
		public function get pnlDelete():DeletePanel
		{
			return this.viewComponent as DeletePanel;
		}
		
	}
}