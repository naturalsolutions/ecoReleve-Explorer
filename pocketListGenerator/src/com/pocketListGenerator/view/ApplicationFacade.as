package com.pocketListGenerator.view
{
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.model.*;
	
	import mx.effects.Fade;
	import mx.managers.ToolTipManager;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.facade.*;
	import org.puremvc.as3.utilities.flex.config.model.ConfigProxy;
	
            
	public class ApplicationFacade extends Facade implements IFacade
	{
		
		// NOTIFICATIONS PUBLICS
		//------------------------------
		
		
		//GESTION DU DEMARRAGE DE L'APPLICATION -------------------------------------
		/** Notification de démarrage de l'application
		 **/
		public static const STARTUP_NOTIFICATION:String = "startup";
		public static const LOAD_PROXIES_NOTIFICATION:String = "loadproxies";
		//---------------------------------------------------------------------------
		
		// GESTION DES AFFICHAGES

		/** Notification pour gérer le spinner: témoin de chargement
		  * Body: true,false (visible ou pas)
		 **/
		public static const DISPLAY_SPINNER:String= "dsiplayspinner";
		//---------------------------------------------------------------------------
		
		//GESTION DE L'UPDATE -------------------------------------------------------
		/** Notification pour gérer l'affichage du panel d'update de l'application
		 * Body: true,false (visible ou pas)
		 **/
		public static const DISPLAY_UPDATE_PANEL:String= "dsiplayUpdatePanel";
		//---------------------------------------------------------------------------
		
		//GESTION DU THESAURUS-------------------------------------------------------
		/** Notifications pour la gestion du chargement du thesaurus
		 **/
		public static const LOADING_THESAURUS_COMPLETE_NOTIFICATION:String = "loadthesauruscomplete";
		
		/** Notifications pour l'appel au webservice thesaurus:
		  * Body: Filtre
		 **/
		public static const THESAURUS_GET_NOTIFICATION:String="thesaurusget";
		//---------------------------------------------------------------------------
		
		//GESTION DE LA CONNEXION-------------------------------------------------------
		/** Notifications pour se connecter
		 **/
		public static const DECONNEXION_NOTIFICATION:String = "deconnexion";
		public static const CONNEXION_TRY_NOTIFICATION:String = "connexiontry";
		public static const CONNEXION_UNAUTHORIZED_NOTIFICATION:String = "connexionunauthorized";
		public static const CONNEXION_FAILED_NOTIFICATION:String = "connexionfailed";
		public static const CONNEXION_AUTHORIZED:String = "connexionauthorized";
		//---------------------------------------------------------------------------
		
		//GESTION DES DONNEES-------------------------------------------------------
		/** Notifications pour la gestion du chargement des données
		 **/
		public static const TRY_LOAD_NOTIFICATION:String = "load";

		/** Notifications pour la gestion du chargement des données sites
		 * Body: sites arraycollection of SiteVO
		 **/
		public static const SITES_LOADED_NOTIFICATION:String = "sitesloaded";
		
		/** Notifications pour la gestion du chargement des données user
		 * Body: users arraycollection of UserVO
		 **/
		public static const USERS_LOADED_NOTIFICATION:String = "usersloaded";
		
		/** Notifications pour la gestion du chargement des données taxa
		 * Body: taxa arraycollection of TaxaVO
		 **/
		public static const TAXA_LOADED_NOTIFICATION:String = "taxaloaded";
		/** Notifications pour la gestion du chargement des données taxa
		 * Body: thesaurusVO
		 **/
		public static const TAXA_GET_NOTIFICATION:String = "taxaget";
		//---------------------------------------------------------------------------
		
		
		//GESTION DES ERREURS-------------------------------------------------------
		/** Notifications d'erreur
		 **/
		public static const SHOW_ERROR_NOTIFICATION:String = "showError";
		public static const ERROR_IO_NOTIFICATION:String = "ioerror";
		public static const ERROR_HTTP_NOTIFICATION:String = "httperror";
		public static const ERROR_MSG_NOTIFICATION:String = "msgerror";
		//---------------------------------------------------------------------------
		
		/** Methode permettant d’appeler le singleton
		 **/
		public static function getInstance():ApplicationFacade
		{
			if (instance == null)
		     		instance = new ApplicationFacade();
		     return instance as  ApplicationFacade;
		}
		
		/** Enregistrement des commandes
		 **/
		override protected function initializeController():void
		{
			super.initializeController();
		     
			//DATA
		     registerCommand(THESAURUS_GET_NOTIFICATION, ThesaurusGetCommand);
			 registerCommand(TAXA_GET_NOTIFICATION, TaxaGetCommand);
		     
			 //LOGIN
			 registerCommand(CONNEXION_TRY_NOTIFICATION, TryConnexionCommand);
			 registerCommand(CONNEXION_AUTHORIZED, LoadUserAndSiteCommand);
		     
		     //LUNCH COMMAND
		     registerCommand(STARTUP_NOTIFICATION, ApplicationStartupCommand);
		     registerCommand(LOAD_PROXIES_NOTIFICATION, LoadProxiesCommand);
		     registerCommand(ConfigProxy.SUCCESS,LoadConfigSuccessCommand);
		     registerCommand(ConfigProxy.FAILURE,LoadConfigFailedCommand);
		}
			
		

		/** Lance l’environnement PureMVC, passage d’une référence à l’application
		 **/
		public function startup(app:pocketListGenerator) : void
		{
		   //TOOLTIP MANAGER
      	   var fadeIn:Fade=new Fade;
      	   fadeIn.alphaFrom=0
      	   fadeIn.alphaTo=1
      	   fadeIn.duration=500
      	   ToolTipManager.showEffect=fadeIn
		   ToolTipManager.scrubDelay=0
			   
      	   //Démarre l'application
			sendNotification( STARTUP_NOTIFICATION, app );
		}
	}
}