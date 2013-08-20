package com.pocketListGenerator.view
{
	import com.pocketListGenerator.controller.*;
	import com.pocketListGenerator.view.mycomponents.DataDisplay;
	
	import flash.utils.*;
	
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.command.*;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class DataDisplayMediator extends Mediator implements IMediator
	{
		//nom du médiator
	    public static const NAME:String = "DataDisplayMediator";		
 				
 		//constructeur
        public function DataDisplayMediator(viewComponent:DataDisplay)
        {
            super(NAME, viewComponent); 
			facade.registerMediator(new UserMediator(dataDisplay.MyUser));
			facade.registerMediator(new SiteMediator(dataDisplay.MySite));
			facade.registerMediator(new TaxaMediator(dataDisplay.MyTaxa));
                                      	            
        }    

        protected function get dataDisplay():DataDisplay
        {
            return viewComponent as DataDisplay;
        }
    }
}