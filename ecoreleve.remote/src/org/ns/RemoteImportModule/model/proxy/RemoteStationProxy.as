package org.ns.RemoteImportModule.model.proxy
{	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import org.ns.RemoteImportModule.controller.NotificationConstants;
	import org.ns.RemoteImportModule.model.delegate.LoadXMLDelegate;
	import org.ns.RemoteImportModule.view.ApplicationMediator;
	import org.ns.common.model.VO.QueryVO;
	import org.ns.common.model.VO.RemoteConnectorVO;
	import org.ns.common.model.VO.RemoteDatasourceVO;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
	
	public class RemoteStationProxy extends FabricationProxy implements IResponder
	{
		public static const NAME:String = "stationproxy";
		public var stations:ArrayCollection=new ArrayCollection();

		private var currentQuery:QueryVO
		private var currentConnector:RemoteConnectorVO
		
		private var mode:String="";
		
		public function RemoteStationProxy()
		{
			super(NAME);
		}
		
		//GET ALL STATION for a query
		public function GetStation(query:QueryVO,url:String,strAuthentification:String):void
		{	
			mode="occurence"
			
			//assigne query to currentQuery variable
			currentQuery=query	
			
            var delegate:LoadXMLDelegate = new LoadXMLDelegate(this,url,strAuthentification);
            delegate.send(); 
			CursorManager.setBusyCursor();
        }
        
		public function countStation(url:String,strAuthentification:String):void
		{	
			mode="count"
				
			var delegate:LoadXMLDelegate = new LoadXMLDelegate(this,url,strAuthentification);
			delegate.send(); 
		}
		
        public function result(data:Object) : void
        {   
			switch (mode)
			{
				case "occurence":
					CursorManager.removeBusyCursor();
					sendNotification(NotificationConstants.STATIONS_SELECTED_NOTIFICATIONS,[data,currentQuery],"stations")
					break;
				case "count":
					sendNotification(NotificationConstants.STATIONS_COUNTED_NOTIFICATIONS,[data],"stations")
					break;			
			}

        }
	
        public function fault(obj:Object):void 
        {
			
			var module:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator
				
			CursorManager.removeBusyCursor();
			
        	if (obj is HTTPStatusEvent){
        		
        	}else if (obj is FaultEvent){
        		var strInfo:String = new String((obj as FaultEvent).fault.faultString);
            	//sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,strInfo,"ERROR");
        	}else if (obj is IOErrorEvent){
        		Alert.show("stream error (" + (obj as IOErrorEvent).errorID + ")" ,"info",4,module.app,null,null,4 ,module.app.moduleFactory);
        	}
	
        }
        
	}
}
