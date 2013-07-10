package org.ns.CsvImportModule.view
{
	import org.ns.CsvImportModule.controller.*;
	import org.ns.CsvImportModule.view.components.csvWizard;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Form;
	
	import org.ns.genericComponents.wizard.events.WizardEvent;
	
	import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlexMediator;

	public class ApplicationMediator extends FlexMediator
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
			registerMediator(new csvWizardMediator(app.wizard));
		}
		
		
        public function get app():CsvImportModule
        {
            return viewComponent as CsvImportModule;
        }
    }
}