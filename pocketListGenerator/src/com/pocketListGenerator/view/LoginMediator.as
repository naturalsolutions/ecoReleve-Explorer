package com.pocketListGenerator.view
{
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.view.mycomponents.Login;
	
	import flash.events.Event;
	import flash.filesystem.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class LoginMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "LoginMediator";	
		
		public function LoginMediator(viewComponent:Login)
		{
			super(NAME, viewComponent);
			login.addEventListener(Login.SIGNIN, onSignIn );
		}    

       // Liste les notifications attendues
		override public function listNotificationInterests( ) : Array 
		{
			return [ ApplicationFacade.CONNEXION_UNAUTHORIZED_NOTIFICATION,
					 ApplicationFacade.CONNEXION_FAILED_NOTIFICATION,
					 ApplicationFacade.CONNEXION_AUTHORIZED];
		}
		
		// Gère les notifications
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() ) 
			{
				case ApplicationFacade.CONNEXION_UNAUTHORIZED_NOTIFICATION: 
					login.MySpinner.visible=false;
					login.currentState='Unauthorized';
					login.password.text='';
					break;
				case ApplicationFacade.CONNEXION_FAILED_NOTIFICATION: 
					login.MySpinner.visible=false;
					login.currentState='ConnexionFailed';
					login.password.text='';
					break;
				case ApplicationFacade.CONNEXION_AUTHORIZED: 
					login.MySpinner.visible=false;
					break;
			}
		}
		            
         //fonction de création de la vue DATA       
        protected function onSignIn( event:Event ):void
        {
        	var myUser:UserVO=login.user;
        	    		
    		var AppMed:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
        	
			//active le spinner
			login.MySpinner.visible=true;
			
        	// stockage de l'utilisateur courant (pour authentification au prés des webservices)
        	AppMed.currentUser=myUser;	
    		
    		//envoit la notification de tentative de connexion
			facade.sendNotification(ApplicationFacade.CONNEXION_TRY_NOTIFICATION);
        }		
             
        protected function get login():Login
        {
            return viewComponent as Login;
        }
		
	}
}