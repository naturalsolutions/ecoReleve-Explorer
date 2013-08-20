package com.importCSV.controller
{
	import com.importCSV.model.proxy.FileImportProxy;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;

    
    
    public class ModelPrepCommand extends SimpleCommand implements ICommand
    {
    	// Créer et enregistrer les Proxys avec le Modèle
    	override public function execute( note : INotification ) : void
    	{    		         	
			//Enregistrement des proxys
			facade.registerProxy(new FileImportProxy())
    	}
    }

}