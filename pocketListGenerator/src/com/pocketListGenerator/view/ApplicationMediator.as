package com.pocketListGenerator.view
{
	import air.net.URLMonitor;
	
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.model.VO.MyAppConfigVO;
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.utils.Debug;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ApplicationMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "ApplicationMediator";		
 		
 		// Variables au niveau de l'application
 		// utilisateur courant ==> sert pour l'authentification
 		public var currentUser:UserVO=new UserVO;
		
 		// Objet contenant la configuration	
 		public var currentConfig:MyAppConfigVO= new MyAppConfigVO;
 				
 		//constructeur
        public function ApplicationMediator(viewComponent:Object)
        {
            super(NAME, viewComponent);
            
            facade.registerMediator(new MainDisplayMediator(app.mainDisplay));
			
        }
        
        // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [ ApplicationFacade.LOAD_PROXIES_NOTIFICATION,
					 ApplicationFacade.DECONNEXION_NOTIFICATION ];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			var strObjet:String="";
			
			switch ( note.getName() ) 
			{
				case ApplicationFacade.LOAD_PROXIES_NOTIFICATION:
					var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
					var ns:Namespace = appXml.namespace();
					app.title=currentConfig.appName + " - v." + appXml.ns::version[0]; 
					break;
				case ApplicationFacade.DECONNEXION_NOTIFICATION:
					currentUser=new UserVO;
					break;
			}
		}     
        protected function get app():pocketListGenerator
        {
            return viewComponent as pocketListGenerator;
        }
    }
}