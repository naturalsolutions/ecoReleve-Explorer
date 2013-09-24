package com.ecoReleve.view
{
	import com.ecoReleve.controller.*;
	import com.ecoReleve.model.DatabaseProxy;
	import com.ecoReleve.model.proxy.RemoteConnectorProxy;
	import com.ecoReleve.view.manager.PopManager;
	import com.ecoReleve.view.mycomponents.ribbon.DataPanel.DataPanel;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.common.model.VO.LocalConnectorVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;
	
	import spark.events.IndexChangeEvent;
	
	public class DataPanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "DataPanelMediator";	
		// list des dataset utilisés	
 		public var arrFilters:ArrayCollection=new ArrayCollection;
 		
		public function DataPanelMediator(viewComponent:DataPanel)
		{
			super(NAME, viewComponent);
		}    
		
		override public function onRegister():void
		{
			super.onRegister();
		
			datapanel.addEventListener(DataPanel.GET_DATA_CLICK,getDataClickHandler);
			
			datapanel.addEventListener(DataPanel.Start_service_module,WebserviceHandler);
			var pxyDatabase:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			sendNotification(NotificationConstants.LOAD_PROXIES_NOTIFICATION);
			
		}
		
		public function list(pxyDatabase:DatabaseProxy):void
		{
			var pxyRemoteConnector:RemoteConnectorProxy=retrieveProxy(RemoteConnectorProxy.NAME) as RemoteConnectorProxy;
			pxyRemoteConnector.selectConnectors(pxyDatabase.getSqlConnexion);
			trace("Connectors : "+RemoteConnectorProxy.connectors);
		}
		//REACTIONS
		
		//FUNCTIONS
		private function WebserviceHandler(event:Event):void
		{
			
		}

		private function getDataClickHandler(event:Event):void
		{
			sendNotification(NotificationConstants.SELECT_STATIONS_NOTIFICATION)
		}
		
		//RESPONDER
		public function respondToConnectorsLocalSelected(note:Notification):void
		{
			datapanel.arrLocalModules.removeAll()
			
			
			for each(var connector:LocalConnectorVO in note.getBody() as ArrayCollection){
				datapanel.arrLocalModules.addItem(connector)
			}
		}
		
		public function respondToConnectorsRemoteSelected(note:Notification):void
		{
			datapanel.arrWebServiceModules.removeAll()
			
			
			for each(var connector:RemoteConnectorVO in note.getBody() as ArrayCollection){
				if (connector.rd_type=='webservice'){
					datapanel.arrWebServiceModules.addItem(connector)
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
		
		
		public function reactTolstFile$Change(event:IndexChangeEvent):void
		{
			var connector:LocalConnectorVO=event.currentTarget.selectedItem as LocalConnectorVO
			//sendNotification(NotificationConstants.LOAD_MODULE_NOTIFICATION,[connector])
			event.currentTarget.selectedItem=-1
		}	
		
		
        public function get datapanel():DataPanel
        {
            return viewComponent as DataPanel;
        }
		

		
	}
}