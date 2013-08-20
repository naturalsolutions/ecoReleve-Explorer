package com.ecoReleve.view
{
	import air.update.ApplicationUpdater;
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import com.ecoReleve.controller.*;
	import com.ecoReleve.view.mycomponents.UpdatePanel;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.*;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class UpdatePanelMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "UpdatePanelMediator";	
		public var strUpdateURL:String="";
		// Création de la variable appUpdater pour la MAJ auto de l'application
		public var appUpdater:ApplicationUpdater = new ApplicationUpdater();
		public var timer:Timer;
		
		public function UpdatePanelMediator(viewComponent:UpdatePanel)
		{
			super(NAME, viewComponent);
		}    

		override public function onRegister():void
		{
			super.onRegister();
			
			updatepanel.addEventListener(UpdatePanel.CLICK_YES,clickYesHandler)
			updatepanel.addEventListener(UpdatePanel.CLICK_NO,clickNoHandler)			
				
		}
		
       // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [NotificationConstants.LOAD_PROXIES_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case NotificationConstants.LOAD_PROXIES_NOTIFICATION:
					var AppMed:ApplicationMediator=retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;	
					strUpdateURL=AppMed.currentConfig.updateURL;
					//checkForUpdates()
					break;
			}
		}
		
		/** Vérifie si il y a une MAJ sur le serveur
		 **/
		private function checkForUpdates():void
		{
		    appUpdater.addEventListener(UpdateEvent.INITIALIZED, updateCheckNow);
		    appUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS,onUpdateStatus);
		   // appUpdater.isNewerVersionFunction=customFn
		    appUpdater.updateURL = strUpdateURL;
		    appUpdater.initialize();
		}   

		/* Regle personalisé de comparaison de version
		private function customFn(currentVersion:String, updateVersion:String):Boolean 
		{
		    return updateVersion > currentVersion;
		}*/

		       
        /** Effectue la mise à jour de l'application
        **/
		private function updateCheckNow(event:UpdateEvent):void
		{
		    appUpdater.checkNow();
		}
		 
		/** affiche les infos concernant l'update
        **/
		private function onUpdateStatus(event:StatusUpdateEvent):void
		{
		  	event.preventDefault()
			if ( event.available ) {
				// show panel
				sendNotification(NotificationConstants.DISPLAY_UPDATE_PANEL,true)
				updatepanel.strVersion=event.version;
			}else {
				//application is up to date
				sendNotification(NotificationConstants.DISPLAY_UPDATE_PANEL,false)
				updatepanel.strVersion="";
			}
		}           
        
        /** CLICK YES ==> do MAJ
        **/
		private function clickYesHandler(event:Event):void
		{
		   updatepanel.prgBar.source=appUpdater
		   updatepanel.prgBar.visible=true
		   
		   appUpdater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR,downloadErrorHandler)
		   appUpdater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE,downloadCompleteHandler)
		   appUpdater.currentState;
		   appUpdater.downloadUpdate();
		   
		}
        
        /** CLICK NO ==> close panel
        **/
		private function clickNoHandler(event:Event):void
		{
		  //Close panel 
		  sendNotification(NotificationConstants.DISPLAY_UPDATE_PANEL,false) 
		}
		
		/** Error during download
        **/
		private function downloadErrorHandler(event:DownloadErrorEvent):void
		{
		    //Error downloading update file, try again later.
		    //Alert.show("ID:" + event.errorID + " subID:" + event.subErrorID + " subID:" + event.text)
		    updatepanel.currentState="Error"
		}
		
		/** Download complete:init timer 3s before installing
        **/
		private function downloadCompleteHandler(event:UpdateEvent):void
		{
		   event.preventDefault();
		   
		   timer=new Timer(1000,3);
		   timer.addEventListener(TimerEvent.TIMER,timerHandler)
		   timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler)
		   timer.start();
		   updatepanel.currentState="BeforeInstall";
		   
		}
        
        /** Timer hanler
        **/
		private function timerHandler(event:TimerEvent):void
		{
			updatepanel.strNbSec= String(timer.repeatCount - timer.currentCount)
		}
        
        /** INSTALL UPDATE
        **/
		private function timerCompleteHandler(event:TimerEvent):void
		{
			appUpdater.installUpdate() 
		}
        
        protected function get updatepanel():UpdatePanel
        {
            return viewComponent as UpdatePanel;
        }
		
	}
}