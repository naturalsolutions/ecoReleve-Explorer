package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.model.ThesaurusProxy;
	import com.pocketListGenerator.model.VO.ThesaurusFiltreVO;
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.view.ApplicationMediator;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;


	public class ThesaurusGetCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			//Création de la chaine d'authentification à partir de l'utilisateur courant 
			var AppMed:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var myUser:UserVO=AppMed.currentUser;
			var strAuthentification:String=UserVO.toAuth(myUser);
			
			//transformation du filtre en critère (string)
			var strCriteria:String="";			
			var myFilter:ThesaurusFiltreVO=notification.getBody() as ThesaurusFiltreVO;
			strCriteria=ThesaurusFiltreVO.toNsHttpStr(myFilter);

			//récupère l'url des webservices		
			var strUrlWS:String=AppMed.currentConfig.serveurURL	+ "/" +	AppMed.currentConfig.wsName

			//Lance le proxy pour charger les stations
			var thesaurusProxy:ThesaurusProxy;
			thesaurusProxy = facade.retrieveProxy(ThesaurusProxy.NAME) as ThesaurusProxy;
				
			//le paramêtre string vide entraine un get all
			thesaurusProxy.GetThesaurus(strUrlWS,strCriteria,strAuthentification);
		}		
	}
}