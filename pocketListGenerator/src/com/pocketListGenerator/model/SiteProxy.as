package com.pocketListGenerator.model
{	
	import com.pocketListGenerator.model.VO.SiteVO;
	import com.pocketListGenerator.model.delegate.LoadXMLDelegate;
	import com.pocketListGenerator.utils.Debug;
	import com.pocketListGenerator.view.ApplicationFacade;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SiteProxy extends Proxy implements IProxy,IResponder
	{
		public static const NAME:String = "siteproxy";
		
		public var urlWebservice:String ="rest/pocketData/monitoredSites"
		public var sites:ArrayCollection=new ArrayCollection();
		
		public function SiteProxy()
		{
			super(NAME);
		}
		        
		//Récupère (GET) 
		public function GetSite(strUrlWs:String,strCriteria:String,strAuthentification:String):void
		{
			var url:String=strUrlWs + "/" + urlWebservice + strCriteria;			
			Debug.doTrace(this,url);
			var delegate:LoadXMLDelegate = new LoadXMLDelegate(this,url,strAuthentification,'site');
			delegate.send();           
		}
        
        public function result(data:Object) : void
        {            
        	//récupère le résultat sous forme XML            
            Debug.doTrace(data)
			var strData:String=String(data);	
			var arr:Vector.<String>=Vector.<String>(strData.split("\n"))
			var len:int=arr.length
			
			for (var i:int=1;i<len-1;i++){
				sites.addItem(SiteVO.fromCSV(arr[i],";"))
			}
            
			sendNotification(ApplicationFacade.SITES_LOADED_NOTIFICATION,sites,"site")
        }
        
        public function fault(obj:Object):void 
        {
        	if (obj is HTTPStatusEvent){
        		switch ((obj as HTTPStatusEvent).status) 
	        	{
	        		case 401:	// Unauthorized
	        			//envoit une notification pour signaler l'erreur lié à l'authorisation
	        			facade.sendNotification(ApplicationFacade.CONNEXION_UNAUTHORIZED_NOTIFICATION);
	        			break;
	        		case 500:   //Autres problèmes
	        			break;
	        	}
        	}else if (obj is FaultEvent){
        		var strInfo:String = new String((obj as FaultEvent).fault.faultString);
            	sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,strInfo,"ERROR");
        	}else if (obj is IOErrorEvent){
        		
        	}	
        }
    
             
	}
}
