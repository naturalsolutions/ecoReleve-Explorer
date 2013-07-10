package org.ns.OdataImportModule.model.proxy
{	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import org.ns.OdataImportModule.controller.NotificationConstants;
	import org.ns.OdataImportModule.model.delegate.LoadXMLDelegate;
	import org.ns.OdataImportModule.view.ApplicationMediator;
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
		
		private var nbTotal:Number=0;
		private var _skip:Number=-1;
		private var _top:Number=-1;
		private var mode:String="";
		private var _url:String="";
		private var _strAuthentification:String="";
		
		public function RemoteStationProxy()
		{
			super(NAME);
		}
		
		//GET ALL STATION for a query
		public function GetStation(url:String,strAuthentification:String,top:Number=-1,skip:Number=-1):void
		{	
			mode="occurence"
			
			if (_url==""){_url=url}
			if (_strAuthentification==""){_strAuthentification=strAuthentification}
			
			if (skip!=-1){
				_skip=skip;
				url+='&$skip=' + skip
			}
			if (top!=-1){
				_top=top;
				url+='&$top=' + top
			}	
				
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
					var xml:XML=new XML(data)
					if (nbTotal==0){nbTotal=Number(xml..*::count.text())}
					sendNotification(NotificationConstants.STATIONS_SELECTED_NOTIFICATIONS,[data,_url,_strAuthentification,_skip,_top,nbTotal],'station')

					break;
				case "count":
					sendNotification(NotificationConstants.STATIONS_COUNTED_NOTIFICATIONS,data,"stations")
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
				switch (mode)
				{
					case "occurence":
						Alert.show("stream error (" + (obj as IOErrorEvent).errorID + ")" ,"info",4,module.app,null,null,4 ,module.app.moduleFactory);
						break;
					case "count":
						sendNotification(NotificationConstants.STATIONS_COUNTED_ERROR_NOTIFICATIONS,null,"ioerror")
						break;			
				}
        	}	
        }
        
	}
}
