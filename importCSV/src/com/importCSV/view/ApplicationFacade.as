package com.importCSV.view
{
	import com.importCSV.controller.*;
	import com.importCSV.model.*;

	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.facade.*;	
            
	public class ApplicationFacade extends Facade implements IFacade
	{
		
		// NOTIFICATIONS PUBLICS
		//------------------------------
		
		
		//GESTION DU DEMARRAGE DE L'APPLICATION -------------------------------------
		/** Notification de démarrage de l'application
		 **/
		public static const STARTUP_NOTIFICATION:String = "startup";
		//---------------------------------------------------------------------------
		
		//GESTION DE L'IMPORT -------------------------------------
		public static const BROWSE_NOTIFICATION:String		  = "browse";
		public static const FILE_SELECTED_NOTIFICATION:String = "fileselected";
		public static const READ_FILE_NOTIFICATION:String 	  = "readfile";
		public static const FILE_READED_NOTIFICATION:String   = "filereaded";
		public static const READ_HEADER_NOTIFICATION:String   = "readheader";
		public static const HEADER_READED_NOTIFICATION:String   = "headerreaded";
		public static const GET_CSV_NOTIFICATION:String   = "getcsv";
		
		public static const FILE_DROPED_NOTIFICATION:String   = "filedroped";
		//----------------------------------------------------------------------------
		
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
		     
			//IMPORT CSV
			registerCommand(BROWSE_NOTIFICATION, BrowseCommand);
			registerCommand(READ_FILE_NOTIFICATION, ReadFileCommand);
			registerCommand(READ_HEADER_NOTIFICATION, ReadHeaderCommand);
			registerCommand(GET_CSV_NOTIFICATION, GetCsvCommand);
			registerCommand(FILE_DROPED_NOTIFICATION, FileDropedCommand);
			
		     //LUNCH COMMAND
		     registerCommand(STARTUP_NOTIFICATION, ApplicationStartupCommand);
		}
			
		

		/** Lance l’environnement PureMVC, passage d’une référence à l’application
		 **/
		public function startup(app:importCSV) : void
		{
      	   //Démarre l'application
			sendNotification( STARTUP_NOTIFICATION, app );
		}
	}
}