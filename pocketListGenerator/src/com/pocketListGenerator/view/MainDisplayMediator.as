package com.pocketListGenerator.view
{
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.utils.Debug;
	import com.pocketListGenerator.view.mycomponents.MainDisplay;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MainDisplayMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "maindisplaymediator";		
 				
 		//constructeur
        public function MainDisplayMediator(viewComponent:MainDisplay)
        {
            super(NAME, viewComponent);
            //facade.registerMediator(new ControlBarMediator(mainDisplay.MyControlBar));
            facade.registerMediator(new LoginMediator(mainDisplay.MyLogin));
			facade.registerMediator(new DataDisplayMediator(mainDisplay.MyDataDisplay));
            //facade.registerMediator(new UpdatePanelMediator(mainDisplay.MyUpdate));
			mainDisplay.addEventListener(MainDisplay.DECONNEXION, onDeconnexion );	        
        }
        
        // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [ApplicationFacade.CONNEXION_AUTHORIZED,
					ApplicationFacade.DISPLAY_UPDATE_PANEL,
					ApplicationFacade.DECONNEXION_NOTIFICATION];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case ApplicationFacade.CONNEXION_AUTHORIZED:
					ChangeDisplayView("DATA");
					
					break;
				case ApplicationFacade.DECONNEXION_NOTIFICATION:
						ChangeDisplayView("LOGIN");		
					break;
				case ApplicationFacade.DISPLAY_UPDATE_PANEL:
					if (note.getBody()==true){
						mainDisplay.MyUpdate.visible=true
					} else {
						mainDisplay.MyUpdate.visible=false
					}
					break; 	
			}
		}     
        
        //fonction de deconnexion     
        protected function onDeconnexion( event:Event ):void
        {
        	//notification de demande de déconnexion
        	sendNotification(ApplicationFacade.DECONNEXION_NOTIFICATION,"login"); 
        }
        
		//Change l'affichage du Display (HOME,DATA)      
        protected function ChangeDisplayView( strDataView:String ):void
        {
        	switch (strDataView) 
			{
				case "LOGIN":
						mainDisplay.currentViewSelector=MainDisplay.LOGIN;
						break;  
				case "DATA":
						mainDisplay.currentViewSelector=MainDisplay.DATA;
						break;
				break;	
			}
        }

        
        protected function get mainDisplay():MainDisplay
        {
            return viewComponent as MainDisplay;
        }
    }
}