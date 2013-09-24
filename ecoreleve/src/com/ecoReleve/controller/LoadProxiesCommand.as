package com.ecoReleve.controller
{
	import com.ecoReleve.model.*;
	import com.ecoReleve.view.DataPanelMediator;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
    
    
    public class LoadProxiesCommand extends SimpleFabricationCommand
    {
    	// Créer et enregistrer les Proxys avec le Modèle
    	override public function execute( note : INotification ) : void
    	{    		
    		//Enregistrement des proxys
         	registerProxy(new ThesaurusProxy());
         	registerProxy(new LoginProxy());
         	registerProxy(new UserProxy());	
         	registerProxy(new GeonameProxy());
			
			//INIT SQLITE
			//open sqlite from applicationStorageDirectory==> user name/Application Data/applicationID.publisherID/Local Store/	
			var dir:File=new File()
			dir.nativePath=File.applicationStorageDirectory.nativePath.replace('ecoReleve','dataConnecteur')
			var sqlFile:File = dir.resolvePath("mydbRW.sqlite");
			
			if (sqlFile.exists){
				var proxyDB:DatabaseProxy=retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
				proxyDB.init(sqlFile);
			}
			var dtm:DataPanelMediator = retrieveMediator(DataPanelMediator.NAME) as DataPanelMediator;
    		dtm.list(proxyDB);	
		}
    }

}