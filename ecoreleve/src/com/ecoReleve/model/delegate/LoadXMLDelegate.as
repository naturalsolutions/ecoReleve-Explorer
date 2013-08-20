package com.ecoReleve.model.delegate
{
	import com.ecoReleve.view.ApplicationFacade;
	
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import com.ecoReleve.utils.Debug;
    import mx.rpc.IResponder;
    import mx.utils.Base64Encoder;
    import mx.rpc.events.ResultEvent;

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
 
    public class LoadXMLDelegate extends Proxy implements IProxy
    {
        private var responder:IResponder;
        private var service:URLRequest;
		private var loader:URLLoader;
		private var strObjet:String;
        
        /** Création du webservice 
		**/
        public function LoadXMLDelegate(responder:IResponder,url:String,strAuthentification:String, myObjet:String) 
        {
      	   
      	   strObjet=myObjet;
      	   service= new URLRequest();
           
           //si le ws nécessite une authentification
           if (strAuthentification!=""){
           		var encoder:Base64Encoder = new Base64Encoder();        
   		   		encoder.encode(strAuthentification);
   		   		service.authenticate=false;
   		   		service.requestHeaders=[ new URLRequestHeader('Authorization','Basic ' + encoder.toString()) ];
           }
           service.url=url; 
           service.method="GET";           
           
		   this.responder = responder;   
        }

		/** Appel au webservice (ajout des listeners)
		**/
        public function send() : void 
        {	
        	loader= new URLLoader;
        	loader.addEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
        	loader.addEventListener(Event.COMPLETE, completeHandler);
        	loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
        	loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);  
			loader.load(service);
			
			//envoit une notification de début de chargement
			sendNotification(ApplicationFacade.DISPLAY_SPINNER,true,strObjet);
        }

		/** Intercepte l'évenement complete
		**/
        private function completeHandler(errData:Event):void
        {
        	//envoit une notification de fin de chargement
        	sendNotification(ApplicationFacade.DISPLAY_SPINNER,false,strObjet);
        	
        	//test pour voir si la réponse est bien de type XML
        	try	{
				var mainXML:XML = new XML(loader.data)
			} catch(errData:Error){
				this.responder.fault(errData);
				return;
			}

 			this.responder.result(loader.data);
        }
        
 		/** Intercepte les messages HTTP
 		 **/
        private function httpStatusHandler(errHTTP:HTTPStatusEvent):void
        {
        	
        	//envoit une notification de fin de chargement
        	sendNotification(ApplicationFacade.DISPLAY_SPINNER,false,strObjet);
        	
        	Debug.doTrace(this,errHTTP)
        	
        	this.responder.fault(errHTTP);
        	
        	//sendNotification(ApplicationFacade.ERROR_HTTP_NOTIFICATION,errHTTP,strObjet);
        }
        
  		/** Intercepte la progression
 		 **/
 		private function progressHandler(event:ProgressEvent):void
 		{
            //envoit la notification pour afficher le spinner de chargement
            Debug.doTrace(this,"progressHandler: " + event.bytesLoaded + "/" + event.bytesTotal );
        } 

        
 		/** Intercepte les erreurs IO 
		**/
        private function ioerrorHandler(errIO:IOErrorEvent):void 
        {
        	//envoit une notification de fin de chargement
        	sendNotification(ApplicationFacade.DISPLAY_SPINNER,false,strObjet);
        	
			Debug.doTrace(this,"ioErrorHandler: " + errIO);
			
			this.responder.fault(errIO);
			//sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,errIO,strObjet);
        }

    }
}
