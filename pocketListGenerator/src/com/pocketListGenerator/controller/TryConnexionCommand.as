package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.model.LoginProxy;
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.view.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class TryConnexionCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			//Création de la chaine d'authentification à partir de l'utilisateur courant 
			var AppMed:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var myUser:UserVO=AppMed.currentUser;
			var strAuthentification:String=UserVO.toAuth(myUser);
			
			//récupère l'url des webservices		
			var strUrlWS:String=AppMed.currentConfig.serveurURL	+ "/" +	AppMed.currentConfig.wsName
			
			//Récupère le proxy 
			var loginProxy:LoginProxy;
			loginProxy = facade.retrieveProxy(LoginProxy.NAME) as LoginProxy;
			
			//Envoit le xml au serveur au format pocketXML
			loginProxy.Connect(strUrlWS,'',strAuthentification);	
		}
		
	}
}