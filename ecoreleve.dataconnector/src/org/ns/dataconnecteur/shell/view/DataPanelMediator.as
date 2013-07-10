package org.ns.dataconnecteur.shell.view
{	
	import org.ns.common.model.VO.LocalConnectorVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import mx.collections.ArrayCollection;
	
	import org.ns.dataconnecteur.shell.controller.*;
	import org.ns.dataconnecteur.shell.view.components.ribbon.DataPanel;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.events.MediatorRegistrarEvent;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class DataPanelMediator extends FlexMediator
	{
		public static const NAME:String = 'DataPanelMediator';
		
		public function DataPanelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);	
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		//RESPONDER
		public function respondToConnectorsLocalSelected(note:Notification):void
		{
			pnlData.arrLocalModules.removeAll()
			
			
			for each(var connector:LocalConnectorVO in note.getBody() as ArrayCollection){
				pnlData.arrLocalModules.addItem(connector)
			}
		}
		
		public function respondToConnectorsRemoteSelected(note:Notification):void
		{
			pnlData.arrWebServiceModules.removeAll()
			pnlData.arrWebSemanticModules.removeAll()
			
			for each(var connector:RemoteConnectorVO in note.getBody() as ArrayCollection){
				if (connector.rd_type=='webservice'){
					pnlData.arrWebServiceModules.addItem(connector)
				} else if (connector.rd_type=='semanticweb'){
					pnlData.arrWebSemanticModules.addItem(connector)
				}
			}
		}
		
		//REACTIONS
		public function reactToLstWebService$Change(event:IndexChangeEvent):void
		{
			var connector:RemoteConnectorVO=event.currentTarget.selectedItem as RemoteConnectorVO
			sendNotification(NotificationConstants.LOAD_MODULE_NOTIFICATION,[connector])
			event.currentTarget.selectedItem=-1
		}
		
		public function reactToLstWebSemantic$Change(event:IndexChangeEvent):void
		{
			var connector:RemoteConnectorVO=event.currentTarget.selectedItem as RemoteConnectorVO
			sendNotification(NotificationConstants.LOAD_MODULE_NOTIFICATION,[connector])
			event.currentTarget.selectedItem=-1
		}
		
		public function reactTolstFile$Change(event:IndexChangeEvent):void
		{
			var connector:LocalConnectorVO=event.currentTarget.selectedItem as LocalConnectorVO
			sendNotification(NotificationConstants.LOAD_MODULE_NOTIFICATION,[connector])
			event.currentTarget.selectedItem=-1
		}	
		
		//GETTER		
		public function get pnlData():DataPanel
		{
			return this.viewComponent as DataPanel;
		}
		
	}
}