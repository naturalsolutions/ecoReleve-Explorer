package com.pocketListGenerator.model
{	
	import com.pocketListGenerator.model.delegate.SendXMLDelegate;
	import com.pocketListGenerator.view.*;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LoginProxy extends Proxy implements IProxy,IResponder
	{
		public static const NAME:String = "loginproxy";
		public var DataXml:XML;
		public var items:ArrayCollection;
		
		public var urlLoginWebservice:String ="rest/login"
		
		public function LoginProxy()
		{
			super(NAME);
		}
        
        //tentative de connexion au serveur
        public function Connect(strUrlWs:String,strXmlData:String,strAuthentification:String):void
		{
			var url:String=strUrlWs + "/" + urlLoginWebservice;
            var delegate:SendXMLDelegate = new SendXMLDelegate(this,url,strXmlData,strAuthentification,'login');
            delegate.send();           
        }
          
        public function result(data:Object) : void
        {
        	var DataXml:XML=new XML(data);
        	
        	//Ajoute nom,prénom et groupe à l'utilisateur courant
        	var AppMed:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;

	        AppMed.currentUser.FIRSTNAME=DataXml.nsData.tuserss.USERS.FIRSTNAME.text();
	        AppMed.currentUser.SURNAME=DataXml.nsData.tuserss.USERS.SURNAME.text();
	        AppMed.currentUser.GROUP=DataXml.nsData.tuserss.USERS.GROUP.attribute("id");
	        AppMed.currentUser.GROUP_NAME=DataXml.nsData.tuserss.USERS.GROUP.NAME.text();
        	
   			// change le mode d'affichage de l'appli
   			sendNotification(ApplicationFacade.CONNEXION_AUTHORIZED);      
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
				}
        	}else if (obj is FaultEvent){
        		var strInfo:String = new String((obj as FaultEvent).fault.faultString);
            	sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,strInfo,"ERROR");
        	}else if (obj is IOErrorEvent){
        		switch ((obj as IOErrorEvent).errorID) 
	        	{
	        		case 2032:	// url not reachable
	        			facade.sendNotification(ApplicationFacade.CONNEXION_FAILED_NOTIFICATION);
	        			break;
	        	}
        	}
	
        }
	}
}
