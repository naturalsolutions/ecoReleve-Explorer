package org.ns.RemoteImportModule.model.delegate
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestDefaults;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.utils.Base64Encoder;
	
	import org.ns.RemoteImportModule.view.ApplicationMediator;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
 
    public class LoadXMLDelegate extends FabricationProxy
    {
        private var responder:IResponder;
        private var service:URLRequest;
		private var loader:URLLoader;
        
        /** Création du webservice 
		**/
        public function LoadXMLDelegate(responder:IResponder,url:String,strAuthentification:String) 
        {
      	   service= new URLRequest();
           
           //si le ws nécessite une authentification
           if (strAuthentification!=null){
           		var encoder:Base64Encoder = new Base64Encoder();        
   		   		encoder.encode(strAuthentification);
   		   		service.authenticate=false;
   		   		service.requestHeaders=[ new URLRequestHeader('Authorization','Basic ' + encoder.toString()) ];
           }
		   trace(url)

           service.url=url; 
           service.method="GET";           
           
		   this.responder = responder;   
        }

		/** Appel au webservice (ajout des listeners)
		**/
        public function send() : void 
        {	
			//change default param timeout (30 sec) for contourning IO error
			URLRequestDefaults.idleTimeout=1000*60*5
        	
			loader= new URLLoader;
        	loader.addEventListener(IOErrorEvent.IO_ERROR, ioerrorHandler);
        	loader.addEventListener(Event.COMPLETE, completeHandler);
        	loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
        	loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);  
			loader.load(service);
        }

		/** Intercepte l'évenement complete
		**/
        private function completeHandler(errData:Event):void
        {
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
        	this.responder.fault(errHTTP);
        }
        
  		/** Intercepte la progression
 		 **/
 		private function progressHandler(event:ProgressEvent):void
 		{

        } 

        
 		/** Intercepte les erreurs IO 
		**/
        private function ioerrorHandler(errIO:IOErrorEvent):void 
        {
			this.responder.fault(errIO);
        }

    }
}
