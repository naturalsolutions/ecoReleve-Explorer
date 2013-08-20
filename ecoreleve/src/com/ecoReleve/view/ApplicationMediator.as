package com.ecoReleve.view
{

	import com.ecoReleve.controller.*;
	
	import mx.collections.ArrayCollection;
	
	import org.ns.genericComponents.Updater.UpdaterManager;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

	public class ApplicationMediator extends FabricationMediator
	{
		//nom du médiator
	    public static const NAME:String = "ApplicationMediator";		
 				
 		//constructeur
        public function ApplicationMediator(viewComponent:Object)
        {
            super(NAME, viewComponent);
        }
        
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new MainDisplayMediator(app.mainDisplay));
			
			//UPDATER
			var mgUpdater:UpdaterManager=new UpdaterManager('http://ecoreleve.googlecode.com/files/update_ecoReleve.xml');
			
		}
		
   
        protected function get app():ecoReleve
        {
            return viewComponent as ecoReleve;
        }
    }
}