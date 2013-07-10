package com.ecoReleve.controller
{
	import com.ecoReleve.model.*;
	
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.utilities.flex.config.model.ConfigVO;
    
    
    public class ModelPrepCommand extends SimpleCommand implements ICommand
    {
    	// Créer et enregistrer les Proxys avec le Modèle
    	override public function execute( note : INotification ) : void
    	{    		
    		//Enregistrement des proxys
         	//registerProxy(new StationProxy());
         	//registerProxy(new ThesaurusProxy());
         	//registerProxy(new LoginProxy());
         	//registerProxy(new UserProxy());	
         	//registerProxy(new GeonameProxy());
         	//registerProxy(new stationsDensityProxy());
         	
			//NOUVEAUX PROXY POUR SQLITE
			registerProxy(new DatabaseProxy());
			registerProxy(new DataProxy());
			
         	//get config data from xml file
         	var configProxy:MyAppConfigProxy = new MyAppConfigProxy();
			registerProxy(configProxy);	
			configProxy.retrieveConfig();
		
    	}
    }

}