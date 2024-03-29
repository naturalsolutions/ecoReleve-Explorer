package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.model.UserProxy;
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.view.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class LoadUserCommand extends SimpleCommand implements ICommand
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
			var userProxy:UserProxy
			userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			
			//Envoit le xml au serveur au format pocketXML
			userProxy.GetUsers(strUrlWS,"",strAuthentification);
		}
		
	}
}