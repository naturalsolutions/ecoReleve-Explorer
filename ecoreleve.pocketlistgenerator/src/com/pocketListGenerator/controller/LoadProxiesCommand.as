package com.pocketListGenerator.controller
{
	import com.pocketListGenerator.model.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
    
    
    public class LoadProxiesCommand extends SimpleCommand implements ICommand
    {
    	// Créer et enregistrer les Proxys avec le Modèle
    	override public function execute( note : INotification ) : void
    	{    		
    		//Enregistrement des proxys
         	facade.registerProxy(new ThesaurusProxy());
         	facade.registerProxy(new LoginProxy());
         	facade.registerProxy(new UserProxy());
			facade.registerProxy(new SiteProxy());
			facade.registerProxy(new TaxaProxy());
         	
    	}
    }

}