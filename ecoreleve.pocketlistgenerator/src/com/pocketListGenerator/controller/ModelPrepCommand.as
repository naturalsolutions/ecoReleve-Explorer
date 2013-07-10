package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.model.MyAppConfigProxy;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.utilities.flex.config.model.ConfigVO;
    
    
    public class ModelPrepCommand extends SimpleCommand implements ICommand
    {
    	// Créer et enregistrer les Proxys avec le Modèle
    	override public function execute( note : INotification ) : void
    	{    		         	
         	//get config data from xml file
         	var configProxy:MyAppConfigProxy= new MyAppConfigProxy();
			facade.registerProxy(configProxy);	
			configProxy.retrieveConfig();
    	}
    }

}