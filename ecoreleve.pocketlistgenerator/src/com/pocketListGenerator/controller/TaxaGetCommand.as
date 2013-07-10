package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.model.TaxaProxy;
	import com.pocketListGenerator.model.VO.ThesaurusVO;
	import com.pocketListGenerator.model.VO.UserVO;
	import com.pocketListGenerator.view.ApplicationMediator;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;


	public class TaxaGetCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			//Création de la chaine d'authentification à partir de l'utilisateur courant 
			var AppMed:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator;
			var myUser:UserVO=AppMed.currentUser;
			var strAuthentification:String=UserVO.toAuth(myUser);
			
			//Transform le ThesaurusVO selectionné en critère pour TaxaProxy
			var thesaurusVO:ThesaurusVO=notification.getBody() as ThesaurusVO;
			var strCriteria:String="";
			strCriteria +="?id-father="+thesaurusVO.ID
			strCriteria +="&lg=en";
			strCriteria +="&storage-type=latin";
			strCriteria +="&display-type=common";

			//récupère l'url des webservices		
			var strUrlWS:String=AppMed.currentConfig.serveurURL	+ "/" +	AppMed.currentConfig.wsName

			//Lance le proxy pour charger les stations
			var taxaProxy:TaxaProxy;
			taxaProxy = facade.retrieveProxy(TaxaProxy.NAME) as TaxaProxy;
				
			//le paramêtre string vide entraine un get all
			taxaProxy.GetTaxa(strUrlWS,strCriteria,strAuthentification);
		}		
	}
}