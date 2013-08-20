package org.ns.XmlImportModule.view
{
	import org.ns.XmlImportModule.controller.*;
	import org.ns.XmlImportModule.view.components.xmlWizard
	
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
			registerMediator(new xmlWizardMediator(app.wizard));
		}
		
		
        public function get app():XmlImportModule
        {
            return viewComponent as XmlImportModule;
        }
    }
}