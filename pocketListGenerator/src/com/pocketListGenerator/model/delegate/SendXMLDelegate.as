package com.pocketListGenerator.model.delegate
{
	import com.pocketListGenerator.view.ApplicationFacade;
	
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import com.pocketListGenerator.utils.Debug;
	import mx.rpc.IResponder;
	import mx.utils.Base64Encoder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
    public class SendXMLDelegate extends Proxy implements IProxy
    {
    	private var responder:IResponder;
        private var service:URLRequest;
		private var loader:URLLoader;
		private var strObjet:String;


		/** Création du webservice 
		**/
        public function SendXMLDelegate(responder:IResponder,url:String, dataXML:String,strAuthentification:String, myObjet:String) 
        {
           strObjet=myObjet;
      	   service= new URLRequest();
           var encoder:Base64Encoder = new Base64Encoder();        
   		   encoder.encode(strAuthentification);
           service.url=url;
           service.authenticate=false;
           service.method="POST";           
   	       service.requestHeaders=[ new URLRequestHeader('Authorization','Basic ' + encoder.toString()) ];  
   	       
	       // si il y a des données XML à envoyées
           if (dataXML!=""){
           	   service.requestHeaders.push(new URLRequestHeader( 'X-HTTP-Method-Override', 'PUT'));
	           service.contentType = "application/xml";
	           var myxml:XML=new XML(dataXML);
	           service.data=myxml.toXMLString();	           	
           } else {        	
	           //il faut envoyer un parametre bidon avec la methode post pour ne pas avoir d'erreur HTTP ????
	           var urlVars:URLVariables = new URLVariables();
	           urlVars.bidon = '';
		       service.data= urlVars
           }
           
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
        }

		/** Intercepte l'évenement complete
		**/
        private function completeHandler(errData:Event):void
        {
        	//test pour voir si la réponse est bien de type XML
        	try	{
        		Debug.doTrace(this,loader.data)
				//var mainXML:XML = new XML(loader.data)
			} catch(errData:Error){
				this.responder.fault(errData);
				return;
			}
			Debug.doTrace(this,loader.data)
			this.responder.result(loader.data);
        }
        
 		/** Intercepte les erreurs HTTP
 		 **/
        private function httpStatusHandler(errHTTP:HTTPStatusEvent):void
        {
        	this.responder.fault(errHTTP);
        	//sendNotification(ApplicationFacade.ERROR_HTTP_NOTIFICATION,errHTTP,strObjet);
        }
        
   		/** Intercepte la progression
 		 **/
 		private function progressHandler(event:ProgressEvent):void
 		{
            Debug.doTrace(this,"progressHandler: " + event.bytesLoaded + "/" + event.bytesTotal );
        }   
            
 		/** Intercepte les erreurs IO
		**/
        private function ioerrorHandler(errIO:IOErrorEvent):void 
        {
			//Debug.doTrace(this,"ioErrorHandler: " + errIO);
			this.responder.fault(errIO);
			//sendNotification(ApplicationFacade.ERROR_IO_NOTIFICATION,errIO,strObjet);
        }

    }
}